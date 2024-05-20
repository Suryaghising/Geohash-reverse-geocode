import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoHashRequest {
  final String name;
  final LatLng location;
  final String street;
  final String city;
  final String country;

  GeoHashRequest({
    required this.name,
    required this.location,
    required this.street,
    required this.city,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'geohash': name,
      'coordinate': {
        'latitude': location.latitude,
        'longitude': location.longitude
      },
      'address': {
        'street': street,
        'city': city,
        'country': country
      }
    };
  }
}
