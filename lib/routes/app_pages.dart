import 'package:geohash_reverse_geocode/ui/bindings/geohash_binding.dart';
import 'package:geohash_reverse_geocode/ui/pages/home_page.dart';
import 'package:get/get.dart';

import 'app_route.dart';

class AppPages {
  AppPages._();

  static const kInitial = Routes.kHome;

  static final routes = [
    GetPage(
      name: Routes.kHome,
      page: () => const HomePage(),
      binding: GeoHashBinding()
    ),
  ];
}
