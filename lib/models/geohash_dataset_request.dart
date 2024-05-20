import 'package:geohash_reverse_geocode/models/geohash_dataset.dart';

class GeoHashDataSetRequest {
  final String description;
  final String provinceInfo;
  final int ward;
  final String color;
  final GeoHashDataSet geoHashDataSet;

  GeoHashDataSetRequest(
      {required this.description,
      required this.provinceInfo,
      required this.ward,
      required this.color,
      required this.geoHashDataSet});

  Map<String, dynamic> toJson() {
    return {
      "id": geoHashDataSet.id,
      "name": geoHashDataSet.name,
      "description": description,
      "metaTags": {
        "ProvienceInfo": provinceInfo,
        "ward": ward
      },
      "color": color,
      "geohashes": List<dynamic>.from(geoHashDataSet.geoHashList.map((x) => x.toJson())),
      "rawGeohashes": List<String>.from(geoHashDataSet.rawGeoHashList.map((e) => e.toString())),
    };
  }
}
