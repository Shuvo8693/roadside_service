import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/modules/mechanic_home/controllers/mechanic_service_area_controller.dart';
import 'dart:async';

import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_search_field.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roadside_assistance/app/data/google_api_service.dart';
import 'package:roadside_assistance/app/modules/my_location_selection/controllers/my_location_selection_controller.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:geocoding/geocoding.dart';

class MapServiceAreaView extends StatefulWidget {
  const MapServiceAreaView({super.key});

  @override
  State<MapServiceAreaView> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapServiceAreaView> {
  final MechanicServiceAreaController _mechanicServiceAreaController = Get.put(MechanicServiceAreaController());
  final MyLocationSelectionController _locationSelectionCtrl = Get.put(MyLocationSelectionController());
  late final TextEditingController searchLocationCtrl = TextEditingController();
  GoogleMapController? mapController;
  double _distance = 0.0;
  LatLng? pickedLocation;
  List<String> onChangeTextFieldValue = [];
  final LatLng center = const LatLng(19.432608, -99.133209);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// My current location
  getMyCurrentLocation() async {
    bool isLocationServiceEnabled = await  Geolocator.isLocationServiceEnabled();
    if(!isLocationServiceEnabled){
      Get.snackbar('Location Service', 'Please enable location service');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        Get.snackbar('Location Permission', 'Please enable location permission');
      }
    }
    if(permission == LocationPermission.deniedForever){
      Get.snackbar('Location Permission', 'Please enable location permission');
    }
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() {
        pickedLocation = LatLng(position.latitude, position.longitude);
        moveCamera(pickedLocation!);
      });

    }).catchError((e) {
      print(e);
    });
  }
  /// Search location
  Future<void> goToSearchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location? location = locations.first;
        moveCamera(LatLng(location.latitude, location.longitude));
      }
    } catch (e) {
      print('Error occurred while searching: $e');
    }
  }

  void moveCamera(LatLng target) {
    pickedLocation = target;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15),
      ),
    );
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,       // remove the bar color
      //   surfaceTintColor: Colors.transparent,       // M3 tint fix
      //   systemOverlayStyle: SystemUiOverlayStyle(   // status-bar
      //       statusBarColor: Colors.transparent,       // transparent status bar
      //       statusBarIconBrightness: Brightness.dark // change icons to light if needed
      //   ),
      // ),
      body: Stack(
        children: [
          /// Map
          GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 11.0,
            ),
            circles: {
              Circle(
                circleId: const CircleId('searchArea'),
                center: pickedLocation ?? center,
                radius: _distance * 1000, // Radius in meters
                fillColor: Colors.grey.withValues(alpha: 0.2),
                strokeColor: Colors.grey.withValues(alpha: 0.4),
                strokeWidth: 1,
              )
            },
            onTap: (position) {
              moveCamera(position);
            },
            myLocationEnabled: true,
            markers: {
              if (pickedLocation != null)
                Marker(
                  markerId: MarkerId(pickedLocation.toString()),
                  draggable: true,
                  position: pickedLocation!,
                  onDragEnd: (newPosition) {
                    _locationSelectionCtrl.pickedNewLocation = newPosition;
                    print('New position: ${_locationSelectionCtrl.pickedNewLocation}');
                  },
                ),
            },
          ),

          /// Back button
          Positioned(
            top: 55.h,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),

          /// Search bar at the top
          Positioned(
            top: 40.h,
            left: 25.w,
            right: 15.w,
            child:  CustomSearchField(
              searchCtrl:searchLocationCtrl,
              fillColor: Colors.white,
              iconOnTap: (){
                setState(() {
                  searchLocationCtrl.clear();
                  //_myLocationSelectionController.latLng = null;
                  onChangeTextFieldValue = [];
                });
              },
              suffixIcon: Icons.clear,
              onChanged: (inputValue) async {
                if (inputValue?.isNotEmpty == true) {
                  var result = await GoogleApiService.fetchSuggestions(inputValue!);
                  print(result.toString());
                  setState(() {
                    // latLng = null;
                    onChangeTextFieldValue = result;
                  });
                  print(onChangeTextFieldValue.toString());
                }
              },
            ),
          ),
          /// Use my current location option
          Positioned(
            top: 110.h,
            left: 25.w,
            right: 15.w,
            child: Container(
              height: 70.h,
              width: 200.w,
              color: Colors.white.withValues(alpha: 0.9),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  // Use my current location option
                  ListTile(
                    leading: SvgPicture.asset(AppIcons.paperPlaneIcon,height: 28.h,),
                    title: const Text('Use my current location'),
                    onTap: () {
                      getMyCurrentLocation();
                    },
                  ),
                ],
              ),
            ),
          ),

          /// Location Suggestion List
          Positioned(
            top: 105.h,
            left: 25.w,
            right: 15.w,
            child: onChangeTextFieldValue.isNotEmpty == true
                ? Container(
              height: 200.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: AppColors.gray.withOpacity(0.7),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.sp),
                      bottomRight: Radius.circular(12.sp))),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: onChangeTextFieldValue.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: InkWell(
                      onTap: () {
                        String selectedLocation = onChangeTextFieldValue[index].toString();
                        print(selectedLocation);
                        if (selectedLocation.isNotEmpty == true) {
                          searchLocationCtrl.text = selectedLocation;
                          print(searchLocationCtrl.text);
                        }
                        goToSearchLocation(searchLocationCtrl.text);
                        setState(() {
                          onChangeTextFieldValue=[];
                        });
                      },
                      child: Text(onChangeTextFieldValue[index].toString(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            )
                : const SizedBox.shrink(),
          ),

          /// Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.r,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${_distance.toPrecision(3)} km',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                   SizedBox(height: 8.h),
                  /// Slider
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.blue.withOpacity(0.2),
                      thumbColor: Colors.white,
                      thumbShape:  RoundSliderThumbShape(
                        enabledThumbRadius: 8.r,
                        elevation: 2,
                      ),
                      overlayColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: _distance,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          _distance = value;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// Done Button
                  Obx(() {
                    return CustomButton(
                      loading: _mechanicServiceAreaController.isLoading.value,
                        height: 48.h,
                        onTap: () async {
                          if (pickedLocation != null && _distance != 0.0) {
                            await _mechanicServiceAreaController
                                .selectServiceArea(latLng: pickedLocation,
                                distanceRadius: _distance.toPrecision(3));
                          }
                        }, text: 'Done'
                    );
                  }
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

