package com.example.flutter_app

import android.os.Build
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.MapView
import com.amap.api.maps.AMap
import com.amap.api.maps.model.MyLocationStyle
import android.util.Log
import android.graphics.Color

class MainActivity: FlutterActivity() {

  var myLocationStyle: MyLocationStyle? = null
  var aMap: MapView? = null
  var newMap : AMap? = null
  var address : String = ""
  var city : String = ""

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    if (aMap == null) {
      aMap = MapView(this)
    }
    newMap = aMap!!.map
    newMap!!.moveCamera(CameraUpdateFactory.zoomTo(19.0f))
    myLocationStyle = MyLocationStyle()
    myLocationStyle!!.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE);
    myLocationStyle!!.strokeColor(Color.argb(0, 0, 0, 0))// 设置圆形的边框颜色
    myLocationStyle!!.radiusFillColor(Color.argb(0, 0, 0, 0))// 设置圆形的填充颜色
    myLocationStyle!!.interval(2000) //设置连续定位模式下的定位间隔，只在连续定位模式下生效，单次定位模式下不会生效。单位为毫秒。
    newMap!!.myLocationStyle = myLocationStyle//设置定位蓝点的Style
    newMap!!.isMyLocationEnabled = true// 设置为true表示启动显示定位蓝点
    aMap!!.onCreate(savedInstanceState)
    var totalSize = DataCleanManager.getTotalCacheSize(this)
    Log.e("AmapError", "缓存大小:===="+totalSize)
    GeneratedPluginRegistrant.registerWith(this)
    MapRegistrant.registerWith(this,aMap,city,address)
    NumberViewRegistrant.registerView(this)
    PresmissRegistrant.register(this,this)
  }

  override fun onResume() {
    super.onResume()
    aMap!!.onResume()
  }

  override fun onDestroy() {
    super.onDestroy()
    aMap!!.onDestroy()
  }

  override fun onSaveInstanceState(outState: Bundle?) {
    super.onSaveInstanceState(outState)
    aMap!!.onSaveInstanceState(outState);
  }

}
