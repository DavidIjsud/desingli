package com.example.designli

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.example.designli.local_notifications.NotificationHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(), ActivityCompat.OnRequestPermissionsResultCallback {

    private val CHANNEL : String = "signli.app/channel";
    private val REQUEST_CODE_POST_NOTIFICATIONS = 1
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel( flutterEngine.dartExecutor.binaryMessenger , CHANNEL ).setMethodCallHandler { call, result ->

            when( call.method ){
                "requestPostNotificationsPermission" -> {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_CODE_POST_NOTIFICATIONS)
                    }
                }
                "launchLocalNotification" -> {
                    val arguments = call.arguments as? Map<*, *>
                    if (arguments != null) {
                        val title = arguments["title"] as? String
                        val message = arguments["message"] as? String

                        val notificationHelper :   NotificationHelper  = NotificationHelper( applicationContext , "1" , "Stock/Trades" , 1  );
                        notificationHelper.showNotification( title!! , message!! )
                    } else {
                        result.error("INVALID_ARGUMENT", "Arguments should be a Map", null)
                    }
                }
                else -> NoSuchMethodException()

            }

        }

        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

}
