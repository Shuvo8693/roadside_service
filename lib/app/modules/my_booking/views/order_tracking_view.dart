import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/bottom_sheet_order_details.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/order_progress_bar.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';
import 'package:roadside_assistance/sk_key.dart';

class OrderTrackingView extends StatefulWidget {
  const OrderTrackingView({super.key});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingView> {
  late GoogleMapController _mapController;

  late LatLng _pickupLocation = LatLng(51.5200, -0.1045);
  final LatLng _driverLocation = LatLng(51.5220, -0.0980);

  final List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();
    _fetchRoutePolyline();
  }

  Future<void> _fetchRoutePolyline() async {
    final result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: SKey.googleApiKey,
      request: PolylineRequest(
          origin: PointLatLng(_driverLocation.latitude, _driverLocation.longitude),
          destination:  PointLatLng(_pickupLocation.latitude, _pickupLocation.longitude),
          mode: TravelMode.driving),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoordinates.clear();
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Map layer
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation,
              zoom: 15,
            ),
            mapType: MapType.hybrid,
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: _polylineCoordinates,
                color: AppColors.primaryColor,
                width: 4,
              )
            },
            markers: {
              Marker(
                markerId: MarkerId('pickup'),
                draggable: true,
                position: _pickupLocation,
                onDragEnd: (positionValue)async{
                  _pickupLocation = positionValue;
                await _fetchRoutePolyline();
                  setState(() {});
                }
              ),
              Marker(
                markerId: MarkerId('driver'),
                position: _driverLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            padding: EdgeInsets.only(bottom: 150.h),
          ),
          /// Draggable bottom sheet with order details
          BottomSheetOrderDetails(),

          /// Provider card and action buttons
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 70.h,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      child: Row(
                        children: [
                          CustomNetworkImage(
                            imageUrl:AppConstants.mechanicImage,
                            width: 60.h,
                            height: 60.h,
                            boxFit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Car Mechanic', style: TextStyle(color: Colors.grey)),
                                Text('Darrell Steward', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red),
                            ),
                            child: Text('Cancel', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpacing(8.h),
                  CustomButton(
                      onTap: (){
                    Get.toNamed(Routes.MESSAGEINBOX);
                  }, text: 'Message'),
                ],
              ),
            ),
          ),

          // Bottom progress indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProgressBar(steps: ['Order Confirmed','Out For Pickup','Almost Done'], currentStep: 2,),
          ),
        ],
      ),
    );
  }
}






