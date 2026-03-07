// KeystorePlugin.kt
package com.yourblooo.medmind.keystore

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Native Android Keystore bridge.
 *
 * Manages a hardware-backed AES-256-GCM master key stored in the AndroidKeyStore provider. The
 * master key is used exclusively to encrypt/decrypt the Isar database key — the raw database key
 * bytes are never persisted unencrypted on the device.
 *
 * Channel: com.yourblooo.medmind/keystore
 *
 * Methods: generateKey → void — Creates the hardware-backed master key if it doesn't exist.
 * isKeyAvailable → bool — Returns true if the master key exists in the Keystore. deleteKey → void —
 * Permanently removes the master key (cryptographic erasure). encryptKey → Map — Encrypts [data]
 * bytes; returns {ciphertext: ByteArray, iv: ByteArray}. decryptKey → ByteArray — Decrypts
 * [ciphertext] + [iv]; returns plaintext bytes.
 */
class KeystorePlugin(private val context: Context) : MethodCallHandler {

  companion object {
    private const val ANDROID_KEYSTORE = "AndroidKeyStore"
    private const val KEY_ALIAS = "medmind_master_key"
    private const val TRANSFORMATION = "AES/GCM/NoPadding"
    private const val GCM_TAG_LENGTH = 128 // bits
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "generateKey" -> generateKey(result)
      "isKeyAvailable" -> isKeyAvailable(result)
      "deleteKey" -> deleteKey(result)
      "encryptKey" -> {
        val data =
                call.argument<ByteArray>("data")
                        ?: return result.error(
                                "INVALID_ARGS",
                                "Missing required argument 'data'",
                                null
                        )
        encryptKey(data, result)
      }
      "decryptKey" -> {
        val ciphertext =
                call.argument<ByteArray>("ciphertext")
                        ?: return result.error(
                                "INVALID_ARGS",
                                "Missing required argument 'ciphertext'",
                                null
                        )
        val iv =
                call.argument<ByteArray>("iv")
                        ?: return result.error(
                                "INVALID_ARGS",
                                "Missing required argument 'iv'",
                                null
                        )
        decryptKey(ciphertext, iv, result)
      }
      else -> result.notImplemented()
    }
  }

  // -------------------------------------------------------------------------
  // Key lifecycle
  // -------------------------------------------------------------------------

  /**
   * Generates a hardware-backed AES-256-GCM key in the AndroidKeyStore. No-op if the key already
   * exists.
   */
  private fun generateKey(result: Result) {
    try {
      val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
      if (keyStore.containsAlias(KEY_ALIAS)) {
        result.success(null)
        return
      }

      val keyGenerator =
              KeyGenerator.getInstance(
                      KeyProperties.KEY_ALGORITHM_AES,
                      ANDROID_KEYSTORE,
              )
      val spec =
              KeyGenParameterSpec.Builder(
                              KEY_ALIAS,
                              KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
                      )
                      .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                      .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                      .setKeySize(256)
                      // Does not require screen lock / biometric authentication so the app
                      // can decrypt silently on launch while still benefiting from hardware
                      // isolation.
                      .setUserAuthenticationRequired(false)
                      .build()

      keyGenerator.init(spec)
      keyGenerator.generateKey()
      result.success(null)
    } catch (e: Exception) {
      result.error("KEYSTORE_ERROR", "Failed to generate master key: ${e.message}", null)
    }
  }

  /** Returns true if the master key is present in the AndroidKeyStore. */
  private fun isKeyAvailable(result: Result) {
    try {
      val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
      result.success(keyStore.containsAlias(KEY_ALIAS))
    } catch (e: Exception) {
      result.error("KEYSTORE_ERROR", "Failed to check key availability: ${e.message}", null)
    }
  }

  /**
   * Permanently deletes the master key from the AndroidKeyStore. After this call, any ciphertext
   * encrypted by this key can never be decrypted — this is the cryptographic erasure used during
   * account deletion.
   */
  private fun deleteKey(result: Result) {
    try {
      val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
      if (keyStore.containsAlias(KEY_ALIAS)) {
        keyStore.deleteEntry(KEY_ALIAS)
      }
      result.success(null)
    } catch (e: Exception) {
      result.error("KEYSTORE_ERROR", "Failed to delete master key: ${e.message}", null)
    }
  }

  // -------------------------------------------------------------------------
  // Encrypt / Decrypt
  // -------------------------------------------------------------------------

  /**
   * Encrypts [data] using the hardware-backed master key (AES-256-GCM). Returns a map with:
   * "ciphertext" → ByteArray — the encrypted bytes (includes GCM auth tag) "iv" → ByteArray — the
   * 12-byte GCM initialisation vector (must be
   * ```
   *                              stored alongside the ciphertext for decryption)
   * ```
   */
  private fun encryptKey(data: ByteArray, result: Result) {
    try {
      val secretKey =
              loadSecretKey()
                      ?: return result.error(
                              "KEY_NOT_FOUND",
                              "Master key not found — call generateKey first",
                              null
                      )

      val cipher = Cipher.getInstance(TRANSFORMATION)
      cipher.init(Cipher.ENCRYPT_MODE, secretKey)

      val iv = cipher.iv
      val ciphertext = cipher.doFinal(data)

      result.success(
              mapOf(
                      "ciphertext" to ciphertext,
                      "iv" to iv,
              )
      )
    } catch (e: Exception) {
      result.error("KEYSTORE_ERROR", "Encryption failed: ${e.message}", null)
    }
  }

  /**
   * Decrypts [ciphertext] using the hardware-backed master key (AES-256-GCM). [iv] must be the same
   * 12-byte vector that was produced during encryption. Returns the plaintext as a ByteArray.
   */
  private fun decryptKey(ciphertext: ByteArray, iv: ByteArray, result: Result) {
    try {
      val secretKey =
              loadSecretKey()
                      ?: return result.error(
                              "KEY_NOT_FOUND",
                              "Master key not found — the data cannot be recovered",
                              null
                      )

      val cipher = Cipher.getInstance(TRANSFORMATION)
      val spec = GCMParameterSpec(GCM_TAG_LENGTH, iv)
      cipher.init(Cipher.DECRYPT_MODE, secretKey, spec)

      result.success(cipher.doFinal(ciphertext))
    } catch (e: Exception) {
      result.error("KEYSTORE_ERROR", "Decryption failed: ${e.message}", null)
    }
  }

  // -------------------------------------------------------------------------
  // Internal helpers
  // -------------------------------------------------------------------------

  private fun loadSecretKey(): SecretKey? {
    val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
    return if (keyStore.containsAlias(KEY_ALIAS)) {
      keyStore.getKey(KEY_ALIAS, null) as SecretKey
    } else {
      null
    }
  }
}
