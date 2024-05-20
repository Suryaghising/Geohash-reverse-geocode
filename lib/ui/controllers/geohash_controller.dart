import 'dart:async';
import 'dart:ui';

import 'package:geohash_reverse_geocode/models/BaatoPlace.dart';
import 'package:geohash_reverse_geocode/models/geohash.dart';
import 'package:geohash_reverse_geocode/models/geohash_dataset.dart';
import 'package:geohash_reverse_geocode/models/geohash_dataset_request.dart';
import 'package:geohash_reverse_geocode/models/geohash_request.dart';
import 'package:geohash_reverse_geocode/network/network_helper.dart';
import 'package:geohash_reverse_geocode/repositories/geohash_repository.dart';
import 'package:geohash_reverse_geocode/utils/extension.dart';
import 'package:geohash_reverse_geocode/utils/poly_util.dart';
import 'package:geohash_reverse_geocode/utils/response_status.dart';
import 'package:geohash_reverse_geocode/utils/states.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_geo_hash/geohash.dart' as geoHashPack;

class GeoHashController extends GetxController {
  late GeoHashRepository geoHashRepository;
  GeoHashDataSet? geoHashDataSet;
  States states = States.kLoading;
  String? message;
  LatLng? previousLocation;
  late LatLng currentLocation;
  Set<Marker> markers = {};
  late PolyUtil polyUtil;
  String? selectedMarker;
  bool isLoading = false;
  GeoHashDataSet? _mainGeoHashDataSet;
  Timer? _debounce;

  late GoogleMapController mapController;

  Set<Polygon> polygons = {};

  bool isPinVisible = false;

  @override
  void onInit() {
    super.onInit();
    final networkHelper = NetworkHelper();
    polyUtil = PolyUtil();
    geoHashRepository = GeoHashRepositoryImpl(networkHelper: networkHelper);
    Future.delayed(const Duration(seconds: 1))
        .then((value) => getGeoHashDataSet());
  }

  getGeoHashDataSet() async {
    final responseStatus = await geoHashRepository.getGeoHashDataset();
    if (responseStatus is ResponseSuccess) {
      geoHashDataSet = responseStatus.data;
      _mainGeoHashDataSet = responseStatus.data;
      states = States.kSuccess;
      createMarker(geoHashDataSet!.geoHashList);
      createPolygon(geoHashDataSet!);
    } else {
      message = (responseStatus as ResponseFailure).message;
    }
    update();
  }

  void setMapController(GoogleMapController mapController) {
    this.mapController = mapController;
  }

  updateGeohashDataSet(
      String description, String provinceName, String ward, Color color) async {
    states = States.kLoading;
    update();
    final geoHashDataSetRequest = GeoHashDataSetRequest(
        description: description,
        provinceInfo: provinceName,
        ward: int.parse(ward),
        color: color.toHex(),
        geoHashDataSet: geoHashDataSet!);
    final responseStatus =
        await geoHashRepository.updateGeohashDataSet(geoHashDataSetRequest);
    if (responseStatus is ResponseSuccess) {
      geoHashDataSet = responseStatus.data;
      _mainGeoHashDataSet = responseStatus.data;
      states = States.kSuccess;
      createMarker(geoHashDataSet!.geoHashList);
      createPolygon(geoHashDataSet!);
    } else {
      message = (responseStatus as ResponseFailure).message;
    }
    update();
  }

  navigateToMarker(GeoHash geohash) {
    selectedMarker = geohash.name;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                geohash.coordinate.latitude, geohash.coordinate.longitude),
            zoom: 13),
      ),
    );
    update();
  }

  addGeoHash() async {
    isLoading = true;
    update();
    final myGeoHash = geoHashPack.MyGeoHash();
    final hash = myGeoHash.geoHashForLocation(geoHashPack.GeoPoint(
        currentLocation.latitude, currentLocation.longitude));

    final response = await geoHashRepository.getPlaceDetail(currentLocation);
    if (response is ResponseSuccess) {
      BaatoPlace baatoPlace = response.data;
      final geoRequest = GeoHashRequest(
          name: hash,
          location: currentLocation,
          street: baatoPlace.name,
          city: baatoPlace.city,
          country: baatoPlace.country);
      GeoHashDataSet newGeoHashDataset = geoHashDataSet!;
      newGeoHashDataset.geoHashList.add(GeoHash.fromJson(geoRequest.toJson()));

      final addGeoHashResponse =
          await geoHashRepository.addGeoHash(newGeoHashDataset);
      if (addGeoHashResponse is ResponseSuccess) {
        geoHashDataSet = newGeoHashDataset;
        _mainGeoHashDataSet = newGeoHashDataset;
        createMarker(geoHashDataSet!.geoHashList);
        createPolygon(geoHashDataSet!);
        setPinVisibility(false);
      } else {
        Get.showSnackbar(const GetSnackBar(
          title: 'Could not add.',
        )).show();
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Error occured.',
      )).show();
    }
    isLoading = false;
    update();
  }

  createMarker(List<GeoHash> geoHashList) {
    markers = geoHashList
        .map((point) => Marker(
            markerId: MarkerId(point.name),
            position:
                LatLng(point.coordinate.latitude, point.coordinate.longitude),
            infoWindow: InfoWindow(
                title:
                    '${point.name} (${point.coordinate.latitude}, ${point.coordinate.longitude})',
                snippet:
                    '${point.address.street}, ${point.address.city}, ${point.address.country}'),
            onTap: () {
              navigateToMarker(point);
            }))
        .toSet();
    update();
  }

  createPolygon(GeoHashDataSet geoHashDataSet) {
    final myPolygon = polyUtil.createPolygons(geoHashDataSet);
    polygons = myPolygon;
    update();
  }

  deleteGeohash(GeoHash geohash) async {
    GeoHashDataSet request = geoHashDataSet!;
    request.geoHashList.removeWhere((element) => element.name == geohash.name);
    final response = await geoHashRepository.deleteGeoHash(request);
    if (response is ResponseSuccess) {
      geoHashDataSet = response.data;
      _mainGeoHashDataSet = response.data;
      createMarker(geoHashDataSet!.geoHashList);
      createPolygon(geoHashDataSet!);
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Could not delete.',
      )).show();
    }
  }

  void setPinVisibility(bool visibility) {
    isPinVisible = visibility;
    update();
  }

  searchByAddress(String input) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    geoHashDataSet = GeoHashDataSet(
        id: _mainGeoHashDataSet!.id,
        color: _mainGeoHashDataSet!.color,
        description: _mainGeoHashDataSet!.description,
        metaTag: _mainGeoHashDataSet!.metaTag,
        name: _mainGeoHashDataSet!.name,
        rawGeoHashList: _mainGeoHashDataSet!.rawGeoHashList,
        geoHashList: List<GeoHash>.from(_mainGeoHashDataSet!.geoHashList)
    );
    if (input.trim().length < 3) {
      update();
    } else {
      List<GeoHash> hashes = [];
      _debounce = Timer(const Duration(milliseconds: 500), () {
        for (GeoHash hash in _mainGeoHashDataSet!.geoHashList) {
          if ('${hash.address.street}, ${hash.address.city}, ${hash.address.country}'
              .toLowerCase()
              .contains(input.trim().toLowerCase())) {
            hashes.add(hash);
          }
        }
        geoHashDataSet!.geoHashList = hashes;
        update();
      });
    }
  }


  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
