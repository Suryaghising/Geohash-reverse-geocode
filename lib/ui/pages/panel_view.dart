import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geohash_reverse_geocode/ui/controllers/geohash_controller.dart';
import 'package:get/get.dart';

import 'geo_data_set_header.dart';
import 'geo_hash_chip.dart';
import 'geohash_search_container.dart';

class PanelView extends StatefulWidget {
  const PanelView({super.key, required this.onAddEditGeoHashData});

  final Function() onAddEditGeoHashData;

  @override
  State<PanelView> createState() => _PanelViewState();
}

class _PanelViewState extends State<PanelView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: GetBuilder<GeoHashController>(
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GeoDataSetHeader(
              name: controller.geoHashDataSet?.name ?? '',
              description: controller.geoHashDataSet?.description ?? '',
              onAddEditGeoHashData: widget.onAddEditGeoHashData,
            ),
            const SizedBox(
              height: 16,
            ),
            GeoHashSearchContainer(),
            (controller.geoHashDataSet == null ||
                    controller.geoHashDataSet!.geoHashList.isEmpty)
                ? const Center(
                    child: Text('No geohash found.'),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.start,
                      children:
                          controller.geoHashDataSet!.geoHashList.map((geohash) {
                        return GeoHashChip(
                          geohash: geohash,
                          onTap: () {
                            controller.navigateToMarker(geohash);
                          },
                          bgColor: controller.selectedMarker != null &&
                                  controller.selectedMarker == geohash.name
                              ? colorFromHex(controller.geoHashDataSet!.color)
                              : Colors.white,
                          textColor: controller.selectedMarker != null &&
                                  controller.selectedMarker == geohash.name
                              ? Colors.white
                              : Colors.black,
                          onDelete: () {
                            controller.deleteGeohash(geohash);
                          },
                        );
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
