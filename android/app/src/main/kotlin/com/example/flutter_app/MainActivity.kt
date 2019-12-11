package com.example.flutter_app

import android.os.Build
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.MapView
import com.amap.api.maps.AMap
import com.amap.api.maps.model.MyLocationStyle
import android.util.Log
import android.graphics.Color

class MainActivity: FlutterActivity() {

  var mLocationClient: AMapLocationClient? = null
  var myLocationStyle: MyLocationStyle? = null
  var aMap: MapView? = null
  var newMap : AMap? = null

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
    if (mLocationClient == null) {
      mLocationClient = AMapLocationClient(this)
    }
    mLocationClient!!.setLocationListener(mAMapLocationListener)
    var options = AMapLocationClientOption()
    options.locationMode = AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
    options.interval = 1000
    options.isOnceLocation = false
    mLocationClient!!.setLocationOption(options)
    mLocationClient!!.startLocation()
    aMap!!.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }

  var mAMapLocationListener: AMapLocationListener? = AMapLocationListener { amapLocation ->
    amapLocation!!.let {
      if (it.errorCode == 0) {
        MapRegistrant.registerWith(this,aMap,it.city,it.aoiName)
        Log.e("AmapError","==============================")
        Log.e("AmapError","城市===>" + it.city + "====城区" + it.district + "===" + it.aoiName + "===" + it.street + "===" + it.streetNum)
      } else {
        //定位失败时，可通过ErrCode（错误码）信息来确定失败的原因，errInfo是错误信息，详见错误码表。
        Log.e(
                "AmapError", "location Error, ErrCode:"
                + amapLocation.errorCode + ", errInfo:"
                + amapLocation.errorInfo
        )
      }
    }
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
