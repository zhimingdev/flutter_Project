package com.example.flutter_app

import android.content.Context
import android.view.View
import com.example.liangmutian.randomtextviewlibrary.RandomTextView
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NmuberViewFactory(createArgsCodec: MessageCodec<Any>?,private var number:String?) : PlatformViewFactory(createArgsCodec){
    override fun create(context: Context?, p1: Int, p2: Any?): PlatformView {
        return object :PlatformView{
            override fun dispose() {
            }

            override fun getView(): View {
                println("传递的数据$number")
                var view : RandomTextView = RandomTextView(context)
                view.text = number
                view.setPianyilian(RandomTextView.FIRSTF_FIRST)
                view.start()
                return view
            }

        }
    }
}