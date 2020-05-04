// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationDataAdapter extends TypeAdapter<LocationData> {
  @override
  final typeId = 0;

  @override
  LocationData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationData(
      long: fields[0] as double,
      lat: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocationData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.long)
      ..writeByte(1)
      ..write(obj.lat);
  }
}
