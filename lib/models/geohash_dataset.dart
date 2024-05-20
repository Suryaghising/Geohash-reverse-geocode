import 'geohash.dart';

class GeoHashDataSet {
  final int id;
  final String name;
  final String description;
  final MetaTag metaTag;
  final String color;
  List<GeoHash> geoHashList;
  final List<String> rawGeoHashList;

  GeoHashDataSet(
      {required this.id,
      required this.name,
      required this.description,
      required this.metaTag,
      required this.color,
      required this.geoHashList,
      required this.rawGeoHashList});

  factory GeoHashDataSet.fromJson(Map<String, dynamic> json) => GeoHashDataSet(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      metaTag: MetaTag.fromJson(json['metaTags']),
      color: json['color'],
      geoHashList:
          (json['geohashes'] as List).map((e) => GeoHash.fromJson(e)).toList(),
      rawGeoHashList:
          (json['rawGeohashes'] as List).map((e) => e.toString()).toList());

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "metaTags": {
        "ProvienceInfo": metaTag.provinceInfo,
        "ward": metaTag.ward
      },
      "color": color,
      "geohashes": List<dynamic>.from(geoHashList.map((x) => x.toJson())),
      "rawGeohashes": List<String>.from(rawGeoHashList.map((e) => e.toString())),
    };
  }
}

class MetaTag {
  final String provinceInfo;
  final int ward;

  MetaTag({required this.provinceInfo, required this.ward});

  factory MetaTag.fromJson(Map<String, dynamic> json) => MetaTag(
        provinceInfo: json['ProvienceInfo'],
        ward: int.parse(json['ward'].toString()),
      );
}
