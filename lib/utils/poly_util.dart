import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geohash_reverse_geocode/models/geohash_dataset.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/geohash.dart';

class PolyUtil {
  Set<Polygon> createPolygons(GeoHashDataSet geoHashDataSet) {
    final Set<Polygon> polygons = {};
// Decode the hash value to get the latitude and longitude points
    final points = decodeHash(geoHashDataSet.geoHashList);
    print("polygonformulation ${points}");
// Create a Polygon overlay
    final polygon = Polygon(
      polygonId: PolygonId(geoHashDataSet.name),
      points: points,
      geodesic: true,
      fillColor:
          colorFromHex(geoHashDataSet.color)!, // Set the desired fill color
      strokeColor: Colors.green.withOpacity(.4), // Set the desired stroke color
      strokeWidth: 1, // Set the desired stroke width
    );
// Add the polygon to the list
    polygons.add(polygon);
    return polygons;
  }

  List<LatLng> decodeHash(List<GeoHash> hashList) => hashList
      .map((hash) => LatLng(
            hash.coordinate.latitude,
            hash.coordinate.longitude,
          ))
      .toList();
}
