package com.example.password_management_apps

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Enable screenshot and app-switcher protection
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
