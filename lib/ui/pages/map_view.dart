import 'package:flutter/material.dart';
import 'package:geohash_reverse_geocode/ui/controllers/geohash_controller.dart';
import 'package:geohash_reverse_geocode/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants.dart';
import 'pin_container.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, required this.isDialogOpen});

  final bool isDialogOpen;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GeoHashController controller = Get.find();

  void _onMapCreated(GoogleMapController mapController) {
    controller.setMapController(mapController);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<GeoHashController>(
          builder: (controller) => GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (CameraPosition? cameraPosition) {
              controller.currentLocation = cameraPosition!.target;
              controller.setPinVisibility(true);
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(27.7172, 85.324),
              zoom: 12.0,
            ),
            markers: controller.markers,
            polygons: controller.polygons,
            // onTap: (LatLng location) {
            //   if (widget.isDialogOpen) {
            //   } else {}
            // },
          ),
        ),
        if (controller.isPinVisible)
          const Center(
            child: PinContainer(),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: CustomButton(
                  onPressed: () {
                    controller.addGeoHash();
                  },
                  text: kAddGeoHash)),
        ),
      ],
    );
  }
}
