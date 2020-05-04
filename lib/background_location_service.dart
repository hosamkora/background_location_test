import 'dart:async';
import 'dart:isolate';

import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';

typedef LocationCallBack = void Function(LocationDto);

class BackgroundLocationService {
  static ReceivePort _port;
  static final _isolateName = 'location_service';

  static var _serviceIsRunning = false;
  static bool get serviceIsRunning => _serviceIsRunning;

  static LocationSettings settings;

  BackgroundLocationService._();

  static Future<void> init() async {
    _port = ReceivePort();
    if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
      IsolateNameServer.removePortNameMapping(_isolateName);
    }
    IsolateNameServer.registerPortWithName(_port.sendPort, _isolateName);

    await _initPlatformState();
  }

  static Future<void> _initPlatformState() async {
    await BackgroundLocator.initialize();
    _serviceIsRunning = await BackgroundLocator.isRegisterLocationUpdate();
  }

  static StreamSubscription listen(LocationCallBack callBack) {
    return _port.listen((data) {
      final locationData = data as LocationDto;
      callBack(locationData);
    });
  }

  static void stop() {
    // IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
    _serviceIsRunning = false;
  }

  static void cancel() {
    // _port.close();
    stop();
    IsolateNameServer.removePortNameMapping(_isolateName);
  }

  static void start(LocationSettings locationSettings) {
    BackgroundLocator.registerLocationUpdate(
      _locatorCallBack,
      // androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
        notificationTitle: "Start Location Tracking example",
        notificationMsg: "Track location in background exapmle",
        wakeLockTime: 20,
        autoStop: false,
        interval: 5,
      ),
    );
    _serviceIsRunning = true;
  }

  static void _locatorCallBack(LocationDto location) {
    final sendPort = IsolateNameServer.lookupPortByName(_isolateName);
    sendPort?.send(location);
  }
}
