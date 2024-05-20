import 'package:flutter/material.dart';
import 'package:geohash_reverse_geocode/ui/controllers/geohash_controller.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class GeoHashSearchContainer extends StatelessWidget {
  GeoHashSearchContainer({super.key});

  final GeoHashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: kSearchAddress),
                onChanged: (input) => controller.searchByAddress(input),
              )),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}
