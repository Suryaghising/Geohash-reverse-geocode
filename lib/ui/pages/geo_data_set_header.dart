import 'package:flutter/material.dart';

class GeoDataSetHeader extends StatelessWidget {
  const GeoDataSetHeader({super.key, required this.name, required this.description, required this.onAddEditGeoHashData});

  final String name;
  final String description;
  final Function() onAddEditGeoHashData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(description),
          ],
        ),
        IconButton(
            onPressed: onAddEditGeoHashData,
            icon: const Icon(Icons.edit)),
      ],
    );
  }
}
