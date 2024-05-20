class GeoHash {
  final String name;
  final Coordinate coordinate;
  final Address address;

  GeoHash(
      {required this.name, required this.coordinate, required this.address});

  factory GeoHash.fromJson(Map<String, dynamic> json) => GeoHash(
      name: json['geohash'],
      coordinate: Coordinate.fromJson(json['coordinate']),
      address: Address.fromJson(json['address']));

  Map<String, dynamic> toJson() {
    return {
      'geohash': name,
      'coordinate': coordinate.toJson(),
      'address': address.toJson(),
    };
  }
}

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});

  factory Coordinate.fromJson(Map<String, dynamic> json) =>
      Coordinate(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude
    };
  }
}

class Address {
  final String street;
  final String city;
  final String country;

  Address({required this.street, required this.city, required this.country});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      street: json['street'], city: json['city'], country: json['country']);

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'country': country
    };
  }
}
