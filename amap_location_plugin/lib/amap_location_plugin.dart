import 'dart:async';

import 'package:flutter/services.dart';

class AmapLocationPlugin {

  factory AmapLocationPlugin() {
    if (_instance == null) {
      final MethodChannel methodChannel =
      const MethodChannel('amap_location_plugin/methodchannel');
      final EventChannel eventChannel =
      const EventChannel('amap_location_plugin/eventchannel');
      _instance = AmapLocationPlugin.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  AmapLocationPlugin.private(this._methodChannel, this._eventChannel);

  static AmapLocationPlugin _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  Stream<String> _onLocationFetched;

  /// Fires whenever the location send.
  Stream<String> get onLocationChanged {
    if (_onLocationFetched == null) {
      _onLocationFetched =
          _eventChannel.receiveBroadcastStream().map((dynamic event) => event);
    }
    return _onLocationFetched;
  }

  Future<void> get startLocation =>
      _methodChannel.invokeMethod("startLocation");

  Future<void> get stopLocation => _methodChannel.invokeMethod("stopLocation");

  Future<String> get getLocation => _methodChannel
      .invokeMethod("getLocation")
      .then<String>((dynamic result) => result);
}
