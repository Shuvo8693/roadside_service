import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MyLocationSelectionController extends GetxController {
  LatLng? latLng;
  final TextEditingController pickupLocationCtrl = TextEditingController();
  final _pickedNewLocation = Rxn<LatLng?>();
  set pickedNewLocation(LatLng? value) => _pickedNewLocation.value = value;
  LatLng? get pickedNewLocation => _pickedNewLocation.value;

  Future<void> goToSearchLocationMark(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        var latLngLocation = LatLng(location.latitude, location.longitude);
        latLng = latLngLocation;
        print(latLng);
      }
    } catch (e) {
      print('Error occurred while searching: $e');
    }
  }
}
