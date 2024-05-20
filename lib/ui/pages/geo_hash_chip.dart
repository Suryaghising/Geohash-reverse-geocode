import 'package:flutter/material.dart';
import 'package:geohash_reverse_geocode/models/geohash.dart';

class GeoHashChip extends StatelessWidget {
  const GeoHashChip({super.key, required this.geohash, required this.onTap, this.bgColor, required this.textColor, required this.onDelete});

  final GeoHash geohash;
  final Function() onTap;
  final Color? bgColor;
  final Color textColor;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message:
        '${geohash.address.street}, ${geohash.address.city}, ${geohash.address.country}',
        child: Chip(
          backgroundColor: bgColor,
          label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  geohash.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                Text(
                  '${geohash.coordinate.latitude.toStringAsFixed(4)}..., ${geohash.coordinate.longitude.toStringAsFixed(4)}...',
                  style: TextStyle(
                      fontSize: 12,
                      color: textColor),
                )
              ]),
          deleteIcon: const Icon(Icons.cancel),
          onDeleted: onDelete,
        ),
      ),
    );
  }
}
