import 'package:location_permissions/location_permissions.dart';

class LocationPermessionService {
  final _locationPermissions = LocationPermissions();
  Future<PermissionStatus> checkLocationPermission() async =>
      _locationPermissions.checkPermissionStatus();

  Future<void> requestPermissions(
          LocationPermissionLevel permissionLevel) async =>
      _locationPermissions.requestPermissions(permissionLevel: permissionLevel);
}
