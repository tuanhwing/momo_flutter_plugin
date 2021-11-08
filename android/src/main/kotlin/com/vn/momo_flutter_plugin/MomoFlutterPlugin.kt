package com.vn.momo_flutter_plugin

import android.app.Activity
import androidx.annotation.NonNull
import com.vn.momo_flutter_plugin.Helper.MoMoPaymentStatuses
import com.vn.momo_flutter_plugin.Helper.MomoFlutterPluginChannels
import com.vn.momo_flutter_plugin.Helper.MomoFlutterPluginMethods
import com.vn.momo_flutter_plugin.Manager.MomoPaymentManager
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MomoFlutterPlugin */
class MomoFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var activity : Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, MomoFlutterPluginChannels.eventChannel)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      MomoFlutterPluginMethods.initialize -> {
        MomoPaymentManager.initialize(call.arguments as Boolean?)
      }
      MomoFlutterPluginMethods.makePayment -> {
        val info = call.arguments as HashMap<String, Any>?
        
        if (info == null) {
          result.success( hashMapOf(
                  "status" to MoMoPaymentStatuses.somethingWentWrong,
                  "message" to "payment info isn't HashMap<String, Any> type!")
          )
        }
        else {
          MomoPaymentManager.makePayment(activity, info, result)
        }
      }
      else -> {
        print ("function not found!")
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity as FlutterActivity
    binding.addActivityResultListener(MomoPaymentManager)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}
