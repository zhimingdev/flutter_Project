package com.example.flutter_app
import android.util.Log
import com.amap.api.maps.MapView
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

object MapRegistrant {
    var eventSink: EventChannel.EventSink? = null

    fun registerWith(registry: PluginRegistry?, mapView: MapView?,city : String ,address : String) {
        val key = MapRegistrant::class.java.canonicalName

        if (registry!!.hasPlugin(key)) return
        Log.e("AmapError","类名"+key+",地址信息:"+address)

        val registrar = registry!!.registrarFor(key)                //注册
        val methodChannel = MethodChannel(registrar.messenger(), key)

        val eventChannel = EventChannel(registrar.messenger(), "flutter_event_channel")
        eventChannel.setStreamHandler(object :EventChannel.StreamHandler{
            override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
                eventSink = p1
            }

            override fun onCancel(p0: Any?) {
                eventSink = null
            }

        })

        methodChannel.setMethodCallHandler(object :MethodChannel.MethodCallHandler{
            override fun onMethodCall(methcall: MethodCall, p1: MethodChannel.Result) {
                var map: MutableMap<String, String> = mutableMapOf()
                map["address"] = address
                map["city"] = city
                var jsonObject = JSONObject(map).toString()
                when(methcall.method) {
                    "getAddress" ->  eventSink.let{
                        eventSink!!.success(jsonObject)
                    }
                }
            }

        })
        //返回高德地图api
        registrar.platformViewRegistry().registerViewFactory("MyMap", MapViewFactory(StandardMessageCodec(), mapView!!))
    }
}