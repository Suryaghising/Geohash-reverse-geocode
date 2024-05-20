import 'package:flutter/material.dart';
import 'package:geohash_reverse_geocode/ui/controllers/geohash_controller.dart';
import 'package:get/get.dart';

import '../../utils/states.dart';
import 'map_view.dart';
import 'panel_view.dart';

class WebHome extends StatefulWidget {
  const WebHome({super.key, required this.addEditGeoHashData, required this.isDialogOpen});

  final Function() addEditGeoHashData;
  final bool isDialogOpen;

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {

  final GeoHashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5, child: MapView(isDialogOpen: widget.isDialogOpen)),
        Expanded(
          flex: 3,
          child: GetBuilder<GeoHashController>(
            builder: (controller) {
              return controller.states == States.kSuccess
                  ? PanelView(
                onAddEditGeoHashData: widget.addEditGeoHashData,
              )
                  : controller.states == States.kFailure
                  ? Center(child: Text(controller.message!))
                  : const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        )
      ],
    );
  }
}
