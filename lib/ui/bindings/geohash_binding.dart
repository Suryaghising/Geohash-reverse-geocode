import 'package:geohash_reverse_geocode/ui/controllers/geohash_controller.dart';
import 'package:get/get.dart';

class GeoHashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeoHashController>(
          () => GeoHashController(),
    );
  }
}