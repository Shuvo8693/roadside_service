import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:roadside_assistance/common/widgets/custom_button.dart';

class MapServiceAreaView extends StatefulWidget {
  const MapServiceAreaView({super.key});

  @override
  State<MapServiceAreaView> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapServiceAreaView> {
  final Completer<GoogleMapController> _controller = Completer();
  double _distance = 40.0;

  // Center of the map
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5234, -0.0984), // Approximate location for the area in the image
    zoom: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,       // remove the bar color
        surfaceTintColor: Colors.transparent,       // M3 tint fix
        systemOverlayStyle: SystemUiOverlayStyle(   // status-bar
            statusBarColor: Colors.transparent,       // transparent status bar
            statusBarIconBrightness: Brightness.dark // change icons to light if needed
        ),
      ),
      body: Stack(
        children: [
          /// Map
          GoogleMap(
            initialCameraPosition: _initialPosition,
            mapType: MapType.normal,
            circles: {
              Circle(
                circleId: const CircleId('searchArea'),
                center: _initialPosition.target,
                radius: _distance * 1000, // Radius in meters
                fillColor: Colors.grey.withValues(alpha: 0.2),
                strokeColor: Colors.grey.withValues(alpha: 0.4),
                strokeWidth: 1,
              )
            },
            markers: {
               Marker(
                markerId: MarkerId('currentLocation'),
                position: LatLng(51.5232, -0.0980), // Slightly offset from center
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
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
                  /// Location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                       SizedBox(height: 8.h),
                      Container(
                        padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chicago, USA',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

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
                        '${_distance.toInt()}km',
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
                  CustomButton(
                    height: 48.h,
                      onTap: (){
                      Get.back();
                      }, text: 'Done')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

