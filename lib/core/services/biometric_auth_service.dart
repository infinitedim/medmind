import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthService {
  static const _prefKeyEnabled = 'biometric_lock_enabled';

  final LocalAuthentication _auth;

  BiometricAuthService() : _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKeyEnabled) ?? false;
  }

  Future<void> setEnabled({required bool enabled}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyEnabled, enabled);
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Masuk ke MedMind',
        // local_auth 3.x: options/AuthenticationOptions tidak lagi di-expose.
        // stickyAuth → persistAcrossBackgrounding
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
