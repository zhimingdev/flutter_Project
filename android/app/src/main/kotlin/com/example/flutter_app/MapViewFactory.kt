package com.example.flutter_app

import android.content.Context
import android.view.View
import com.amap.api.maps.MapView
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class MapViewFactory(createArgsCodec: MessageCodec<Any>?, private val mapView: MapView?) :
    PlatformViewFactory(createArgsCodec) {

    override fun create(context: Context, i: Int, o: Any?): PlatformView {
        return object : PlatformView {
            override fun getView(): View? {
                return mapView
            }

            override fun dispose() {

            }
        }
    }
}
