package com.example.flutter_app

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec

object NumberViewRegistrant {

    fun registerView(registry: PluginRegistry?) {
        var number :String? = ""
        val key = NumberViewRegistrant::class.java.canonicalName

        if (registry!!.hasPlugin(key)) return

        val registrar = registry!!.registrarFor(key)
        var methodChannel:MethodChannel = MethodChannel(registrar.messenger(),key)
        methodChannel.setMethodCallHandler { methodCall, _ ->
            when(methodCall.method) {
                "number" -> {
                    number = methodCall.arguments.toString()
                    registrar.platformViewRegistry().registerViewFactory("numberview",NmuberViewFactory(StandardMessageCodec(),number))
                }
            }
        }
    }
}