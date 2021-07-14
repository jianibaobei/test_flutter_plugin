package com.zuhaowan.tencent.protocol.zhw_login

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

/** ZhwLoginPlugin */
/**
 * 此plugin会注册到generated里面 所以这里要把methodchannel 和 eventchennel都实现并且注册 接下来就可以增加自己想增加的一些逻辑处理
 * ActivityResultListener可以监听页面的返回，比如一些需要startactivtyforresult的操作
 * ActivityAware,可以得到当前Activity上下文
 */
class ZhwLoginPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,
  ActivityResultListener, ActivityAware{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventSink: EventChannel.EventSink
  private lateinit var eventChannel: EventChannel
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zhw_login")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"zhw_login_event")
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){
      "getPlatformVersion" -> { result.success("Android ${android.os.Build.VERSION.RELEASE}")}
      "getString" -> eventSink.success("我来测试下发送字符串到客户端")
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
    if (p1 != null) {
      eventSink = p1
    };
  }

  override fun onCancel(p0: Any?) {
  }


  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    TODO("Not yet implemented")
    return true
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    //得到activity上下文
//     activity =  binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}
