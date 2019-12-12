package com.example.flutter_app

import android.Manifest
import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

object PresmissRegistrant {

    const val MANUFACTURER_HUAWEI = "Huawei";//华为
    const val MANUFACTURER_MEIZU = "Meizu";//魅族
    const val MANUFACTURER_XIAOMI = "Xiaomi";//小米
    const val MANUFACTURER_SONY = "Sony";//索尼
    const val MANUFACTURER_OPPO = "OPPO";
    const val MANUFACTURER_LG = "LG";
    const val MANUFACTURER_VIVO = "vivo";
    const val MANUFACTURER_SAMSUNG = "samsung";//三星
    const val MANUFACTURER_LETV = "Letv";//乐视
    const val MANUFACTURER_ZTE = "ZTE";//中兴
    const val MANUFACTURER_YULONG = "YuLong";//酷派
    const val MANUFACTURER_LENOVO = "LENOVO";//联想
    val needPermissions = arrayOf(
        Manifest.permission.ACCESS_COARSE_LOCATION,
        Manifest.permission.ACCESS_FINE_LOCATION
    )

    fun GoToSetting(activity : FlutterActivity) {
        when(Build.MANUFACTURER){
            MANUFACTURER_HUAWEI -> Huawei(activity)
            MANUFACTURER_MEIZU -> Meizu(activity)
            MANUFACTURER_XIAOMI -> Xiaomi(activity)
            MANUFACTURER_SONY -> Sony(activity)
            MANUFACTURER_OPPO -> OPPO(activity)
            MANUFACTURER_LETV -> Letv(activity)
            else -> ApplicationInfo(activity)
        }
    }

    fun Huawei(activity : FlutterActivity) {
        var intent = Intent()
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        intent.putExtra("packageName", activity.packageName)
        var comp = ComponentName("com.huawei.systemmanager", "com.huawei.permissionmanager.ui.MainActivity")
        intent.component = comp
        activity.startActivity(intent)
    }

    fun Meizu(activity : FlutterActivity) {
        var intent = Intent("com.meizu.safe.security.SHOW_APPSEC")
        intent.addCategory(Intent.CATEGORY_DEFAULT)
        intent.putExtra("packageName", activity.packageName)
        activity.startActivity(intent)
    }

    fun Xiaomi(activity : FlutterActivity) {
        var intent = Intent("miui.intent.action.APP_PERM_EDITOR")
        var componentName = ComponentName("com.miui.securitycenter", "com.miui.permcenter.permissions.AppPermissionsEditorActivity")
        intent.component = componentName
        intent.putExtra("extra_pkgname", activity.packageName)
        activity.startActivity(intent)
    }

    fun Sony(activity : FlutterActivity) {
        var intent = Intent()
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK;
        intent.putExtra("packageName", activity.packageName);
        var comp = ComponentName("com.sonymobile.cta", "com.sonymobile.cta.SomcCTAMainActivity")
        intent.component = comp
        activity.startActivity(intent)
    }

    fun OPPO(activity : FlutterActivity) {
        var intent = Intent()
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        intent.putExtra("packageName", activity.packageName)
        var comp = ComponentName("com.color.safecenter", "com.color.safecenter.permission.PermissionManagerActivity")
        intent.component = comp
        activity.startActivity(intent)
    }

    fun Letv(activity : FlutterActivity) {
        var intent = Intent()
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK;
        intent.putExtra("packageName", activity.packageName);
        var comp = ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.PermissionAndApps")
        intent.component = comp;
        activity.startActivity(intent);
    }

    /**
     * 只能打开到自带安全软件
     * @param activity
     */
    fun _360(activity : FlutterActivity) {
        var intent = Intent("android.intent.action.MAIN")
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        intent.putExtra("packageName", activity.packageName)
        var comp = ComponentName("com.qihoo360.mobilesafe", "com.qihoo360.mobilesafe.ui.index.AppEnterActivity")
        intent.component = comp
        activity.startActivity(intent)
    }

    /**
     * 应用信息界面
     * @param activity
     */
    fun ApplicationInfo(activity : FlutterActivity){
        var localIntent = Intent()
        localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        if (Build.VERSION.SDK_INT >= 9) {
            localIntent.action = "android.settings.APPLICATION_DETAILS_SETTINGS"
            localIntent.data = Uri.fromParts("package", activity.packageName, null)
        } else if (Build.VERSION.SDK_INT <= 8) {
            localIntent.action = Intent.ACTION_VIEW
            localIntent.setClassName("com.android.settings", "com.android.settings.InstalledAppDetails")
            localIntent.putExtra("com.android.settings.ApplicationPkgName", activity.packageName)
        }
        activity.startActivity(localIntent)
    }

    /**
     * 系统设置界面
     * @param activity
     */
    fun SystemConfig(activity : FlutterActivity) {
        var intent = Intent(Settings.ACTION_SETTINGS)
        activity.startActivity(intent)
    }

    fun register(activity : FlutterActivity,registry: PluginRegistry?) {
        val key = PresmissRegistrant::class.java.canonicalName
        if (registry!!.hasPlugin(key)) return
        val registrar = registry!!.registrarFor(key)                //注册
        val methodChannel = MethodChannel(registrar.messenger(), key)
        methodChannel.setMethodCallHandler { call, _ ->
            when(call.method) {
                "goSetting" -> {
                    GoToSetting(activity)
                }
            }
        }
    }


}