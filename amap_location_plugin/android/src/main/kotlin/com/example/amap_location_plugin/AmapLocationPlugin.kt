package com.example.amap_location_plugin

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.util.Log
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationListener
import org.json.JSONObject
import java.util.HashMap
import java.util.Map;


class AmapLocationPlugin internal constructor(registrar: Registrar) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler{
  private var mLocation: String? = null
  private var mEventSink: EventChannel.EventSink? = null
  //声明AMapLocationClient类对象
  private var mLocationClient: AMapLocationClient? = null
  private val registrar: PluginRegistry.Registrar
  //异步获取定位结果
  private val mAMapLocationListener = AMapLocationListener { amapLocation ->
    if (amapLocation != null) {
      if (amapLocation.errorCode == 0) {

        mLocation = getLocationInfoMap(amapLocation)
        mEventSink!!.success(mLocation)
        Log.d("onLocationChanged", mLocation)
      }
    }
  }

  private fun getLocationInfoMap(amapLocation: AMapLocation): String {
    val map = HashMap<String, String>()
    map["longitude"] = amapLocation.longitude.toString()
    map["latitude"] = amapLocation.latitude.toString()
    map["province"] = amapLocation.province
    map["info"] = amapLocation.aoiName
    map["city"] = amapLocation.city
    map["district"] = amapLocation.district
    map["address"] = amapLocation.address
    return JSONObject(map).toString()
  }

  init {
    this.registrar = registrar
    //初始化定位
    mLocationClient = AMapLocationClient(registrar.context())

    //设置定位回调监听
    mLocationClient!!.setLocationListener(mAMapLocationListener)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
      call.method.equals("startLocation") -> //启动定位
        mLocationClient!!.startLocation()
      call.method.equals("stopLocation") -> //停止定位
        mLocationClient!!.stopLocation()
      call.method.equals("getLocation") -> result.success(mLocation)
      else -> result.notImplemented()
    }
  }

  override fun onListen(o: Any?, eventSink: EventChannel.EventSink?) {
    this.mEventSink = eventSink
  }

  override fun onCancel(o: Any?) {
    mLocationClient!!.stopLocation()
  }

  companion object {
    private val TAG = "AmapLocationPlugin"

    /**
     * Plugin registration.
     */
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val methodChannel = MethodChannel(registrar.messenger(), "amap_location_plugin/methodchannel")
      val eventChannel = EventChannel(registrar.messenger(), "amap_location_plugin/eventchannel")
      val instance = AmapLocationPlugin(registrar)
      methodChannel.setMethodCallHandler(instance)
      eventChannel.setStreamHandler(instance)
    }
  }
}
