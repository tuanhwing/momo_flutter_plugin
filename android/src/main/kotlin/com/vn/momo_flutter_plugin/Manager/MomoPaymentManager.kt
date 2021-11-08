package com.vn.momo_flutter_plugin.Manager

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import com.vn.momo_flutter_plugin.Helper.MoMoPaymentStatuses
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import vn.momo.momo_partner.AppMoMoLib
import vn.momo.momo_partner.utils.MoMoConfig


object MomoPaymentManager: PluginRegistry.ActivityResultListener {

    private var momoFlutterResult:Result? = null

    private var isDevelopment:Boolean = false

    /**
     * Initialization
     */
    internal fun initialize(develop: Boolean?) {
        print("initialize start!")
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT);
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN);
        isDevelopment = (develop == null || develop);

        AppMoMoLib.getInstance().setEnvironment(
                if (isDevelopment)
                    AppMoMoLib.ENVIRONMENT.DEVELOPMENT
                else
                    AppMoMoLib.ENVIRONMENT.PRODUCTION
        )
        print("initialize end!")
    }

    private fun isPackageInstalled(packageName: String?, packageManager: PackageManager): Boolean {
        return try {
            packageManager.getApplicationInfo(packageName!!, 0).enabled
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    /**
     * Make payment request with information
     */
    internal fun makePayment(activity: Activity, info: Map<String, Any>, result: Result) {
        print("makePayment")

        momoFlutterResult = result

        ///Check app is installed or not
        val packageManager: PackageManager = activity.getPackageManager()
        val packageName:String = if (isDevelopment) MoMoConfig.MOMO_APP_PAKAGE_CLASS_DEVELOPER else MoMoConfig.MOMO_APP_PAKAGE_CLASS_PRODUCTION
        val appInstalled:Boolean = isPackageInstalled(packageName, packageManager)

        if (appInstalled) {
            val paymentInfo: HashMap<String, Any> = info as HashMap<String, Any>
            AppMoMoLib.getInstance().requestMoMoCallBack(activity, paymentInfo)
        }
        else {
            momoFlutterResult?.success(hashMapOf(
                    "status" to MoMoPaymentStatuses.appNotInstalled,
                    "message" to "MoMo [$packageName] application isn't installed!")
            )
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO) {
                print("momo onActivityResult")
                val result: HashMap<String, Any> = java.util.HashMap()

                val status = data?.getIntExtra("status", MoMoPaymentStatuses.somethingWentWrong)
                val token = data?.getStringExtra("data")
                val phonenumber = data?.getStringExtra("phonenumber")
                val message = data?.getStringExtra("message")
                val extra = data?.getStringExtra("extra")

                result["status"] = status ?: MoMoPaymentStatuses.somethingWentWrong
                result["phoneNumber"] = phonenumber.toString()
                result["token"] = token.toString()
                result["message"] = message.toString()
                result["extra"] = extra.toString()

                momoFlutterResult?.success(result)
            }
        }
        return true
    }
}