import 'package:geohash_reverse_geocode/models/BaatoPlace.dart';
import 'package:geohash_reverse_geocode/models/geohash_dataset.dart';
import 'package:geohash_reverse_geocode/models/geohash_dataset_request.dart';
import 'package:geohash_reverse_geocode/network/network_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../utils/constants.dart';
import '../utils/response_status.dart';

abstract class GeoHashRepository {
  Future<ResponseStatus> getGeoHashDataset();
  Future<ResponseStatus>updateGeohashDataSet(GeoHashDataSetRequest geoHashDataSetRequest);
  Future<ResponseStatus> getPlaceDetail(LatLng currentLocation);
  Future<ResponseStatus>addGeoHash(GeoHashDataSet geoHashDataSet);
  Future<ResponseStatus> deleteGeoHash(GeoHashDataSet request);
}

class GeoHashRepositoryImpl implements GeoHashRepository {
  final NetworkHelper networkHelper;

  GeoHashRepositoryImpl({required this.networkHelper});

  @override
  Future<ResponseStatus> getGeoHashDataset() async {
    final response = await networkHelper.getRequest('/geohash');
    final data = response.data;
    if (response.statusCode == 200) {
      final geoDataHashSet = GeoHashDataSet.fromJson(data);
      return ResponseSuccess(geoDataHashSet);
    } else {
      return ResponseFailure(data['message']);
    }
  }

  @override
  Future<ResponseStatus> updateGeohashDataSet(GeoHashDataSetRequest geoHashDataSetRequest) async{
    final response = await networkHelper.patchRequest('/geohash', data: geoHashDataSetRequest.toJson());
    final data = response.data;
    if (response.statusCode == 200) {
      final geoDataHashSet = GeoHashDataSet.fromJson(data);
      return ResponseSuccess(geoDataHashSet);
    } else {
      return ResponseFailure(data['message']);
    }
  }

  @override
  Future<ResponseStatus> getPlaceDetail(LatLng currentLocation) async{
    final response = await networkHelper.getRequest('https://api.baato.io/api/v1/reverse?key=$kBaatoKey&lat=${currentLocation.latitude}&lon=${currentLocation.longitude}');
    final data = response.data;
    if (response.statusCode == 200) {
      final object = data['data'] as List;
      final array = object.map((e) => BaatoPlace.fromJson(e)).toList();
      final baatoPlace = array.first;
      return ResponseSuccess(baatoPlace);
    } else {
      return ResponseFailure(data['message']);
    }
  }

  @override
  Future<ResponseStatus> addGeoHash(GeoHashDataSet geoRequest) async{
    final response = await networkHelper.patchRequest('/geohash', data: geoRequest.toJson());
    final data = response.data;
    if (response.statusCode == 200) {
      return ResponseSuccess(GeoHashDataSet.fromJson(data));
    } else {
      return ResponseFailure(data['message']);
    }
  }

  @override
  Future<ResponseStatus> deleteGeoHash(GeoHashDataSet request) async{
    final response = await networkHelper.patchRequest('/geohash', data: request.toJson());
    final data = response.data;
    if (response.statusCode == 200) {
      return ResponseSuccess(GeoHashDataSet.fromJson(data));
    } else {
      return ResponseFailure(data['message']);
    }
  }
}
