import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

part 'location_cache.g.dart';

@singleton
class LocationCache {
  static final cacheName = 'loaction_logs';
  final Box<LocationData> box;

  LocationCache(this.box);

  @factoryMethod
  static Future<LocationCache> init() async {
    Box<LocationData> _box;
    if (Hive.isBoxOpen(cacheName))
      _box = Hive.box<LocationData>(cacheName);
    else
      _box = await Hive.openBox<LocationData>(cacheName);
    return LocationCache(_box);
  }

  void add(LocationData locationData) => box.add(locationData);

  void clear() => box.clear();
}

@HiveType(typeId: 0)
class LocationData {
  @HiveField(0)
  final double long;
  @HiveField(1)
  final double lat;

  LocationData({
    @required this.long,
    @required this.lat,
  });

  @override
  String toString() => 'LocationData(long: $long, lat: $lat)';
}
