package com.yourblooo.medmind

import com.yourblooo.medmind.health_connect.HealthConnectPlugin
import com.yourblooo.medmind.keystore.KeystorePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(
                    flutterEngine.dartExecutor.binaryMessenger,
                    "com.yourblooo.medmind/health_connect",
            )
            .setMethodCallHandler(HealthConnectPlugin(this))

    MethodChannel(
                    flutterEngine.dartExecutor.binaryMessenger,
                    "com.yourblooo.medmind/keystore",
            )
            .setMethodCallHandler(KeystorePlugin(this))
  }
}
