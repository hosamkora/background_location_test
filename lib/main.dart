import 'dart:async';

import 'package:background_location_test/background_location_service.dart';
import 'package:background_location_test/get_it_configure.dart';
import 'package:background_location_test/location_cache.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LocationDataAdapter());
  configure();
  await locator.allReady();

  runApp(MyApp());
  await BackgroundLocationService.init();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final list = <String>[];
  StreamSubscription locationSubscription;
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    locationSubscription = BackgroundLocationService.listen((data) {
      // list.add('${DateTime.now()}: ${data.longitude} , ${data.latitude}');
      // setState(() {});
      final location = LocationData(
        long: data.longitude,
        lat: data.latitude,
      );
      locator.get<LocationCache>().add(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _startServiceLocator();
              },
              child: Text('start'),
            ),
            RaisedButton(
              onPressed: () {
                _stopServiceLocator();
              },
              child: Text('stop'),
            ),
            RaisedButton(
              onPressed: () {
                locator.get<LocationCache>().clear();
              },
              child: Text('clear'),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<LocationData>>(
                valueListenable: locator.get<LocationCache>().box.listenable(),
                builder: (_, box, __) => ListView(
                  children: <Widget>[
                    for (var item in box.values)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${DateTime.now()}: ${item.toString()}'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          _startServiceLocator();
        } else {
          // show error
        }
        break;
      case PermissionStatus.granted:
        _startServiceLocator();
        break;
    }
  }

  void _startServiceLocator() {
    BackgroundLocationService.start(
      LocationSettings(
        notificationTitle: "Start Location Tracking example",
        notificationMsg: "Track location in background exapmle",
        wakeLockTime: 20,
        autoStop: false,
        interval: 5,
      ),
    );
  }

  void _stopServiceLocator() {
    BackgroundLocationService.stop();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }
}
