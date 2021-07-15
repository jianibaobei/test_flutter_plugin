
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class ZhwLogin {

  final  MethodChannel _channel ;
  final  EventChannel _eventChannel ;
  static ZhwLogin _instance;
  //如果有多个分发结果需要处理，可以定义多个StreamController，然后在客户端进行监听
  //StreamController的类型 T 可以是任何类型，对象，map等都可以，接收的时候亦如此接收即可
  StreamController<String> _getStringStreamController =   StreamController.broadcast();
  //客户端监听 initState()方法中 ZhwLogin().getStringResp.listener((event) {})
  Stream<String> get getStringResp  =>  _getStringStreamController.stream;

  //factory Flutter单例模式，在这里面进行初始化操作
  factory ZhwLogin(){
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel("zhw_login");
      final EventChannel eventChannel = const EventChannel('zhw_login_event');
      //初始化操作
      _instance = ZhwLogin._private(methodChannel, eventChannel);
    }
    return _instance;
  }
  ZhwLogin._private(this._channel,this._eventChannel){
    //初始化监听
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

   Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void  getString(){
    _channel.invokeMethod("getString");
  }

  void parseGetStringNotification(String eventString){
    _getStringStreamController.add(eventString);
  }

  void _onEvent(Object event) {
    print("监听到Android端EventChannel返回==$event");
    if (event != null) {
      String eventString = event;
      try {
        //在这里做一些监听到参数的处理，可能会同步通知很多
        // final imMap = json.decode(eventString);
        parseGetStringNotification(eventString);
        //监听到数据之后做各种解析
      } on FormatException catch (e) {
        print(e.message);
      } on NoSuchMethodError catch (e) {
        print(e.toString());
      }
    }
  }
  //错误监听这个不用管
  void _onError(Object error) {
    print("ZhwLogin - ${error.toString()}");
  }


}
