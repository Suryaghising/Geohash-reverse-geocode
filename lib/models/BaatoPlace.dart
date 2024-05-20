class BaatoPlace {
  final num placeId;
  final String name;
  final String city;
  final String country;

  BaatoPlace(
      {required this.placeId,
      required this.name,
      required this.city,
      required this.country});

  factory BaatoPlace.fromJson(Map<String, dynamic> json) => BaatoPlace(
      placeId: json['placeId'],
      name: json['name'],
      city: _getCity(json['address']),
      country: _getCountry(json['address']));

  static String _getCity(String address) {
    final addressList = address.split(',');
    if(addressList.length < 2) {
      return address;
    } else {
      return addressList[0];
    }
  }

  static String _getCountry(String address) {
    final addressList = address.split(',');
    if(addressList.length < 2) {
      return address;
    } else {
      return addressList.last;
    }
  }
}
