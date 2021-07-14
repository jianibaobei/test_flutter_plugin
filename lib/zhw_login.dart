
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class ZhwLogin {

  final  MethodChannel _channel ;
  final  EventChannel _eventChannel ;
  static ZhwLogin _instance;
  StreamController<String> _getStringStreamController =   StreamController.broadcast();
  Stream<String> get getStringResp  =>  _getStringStreamController.stream;

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
  void _onError(Object error) {
    print("FlutterNIM - ${error.toString()}");
  }


}
