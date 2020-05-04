import 'package:background_location_test/get_it_configure.iconfig.dart';
import 'package:background_location_test/location_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final locator = GetIt.instance;

@injectableInit
void configure() => $initGetIt(locator);
