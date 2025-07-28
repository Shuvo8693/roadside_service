import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/modules/mechanic_order/controllers/order_details_controller.dart';

import 'package:roadside_assistance/app/modules/my_booking/controllers/order_tracking_controller.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/bottom_sheet_order_details.dart';
import 'package:roadside_assistance/app/modules/my_booking/widgets/order_progress_bar.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';
import 'package:roadside_assistance/sk_key.dart';

import '../../mechanic_order/model/order_details_model.dart';

class OrderTrackingView extends StatefulWidget {
  const OrderTrackingView({super.key});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingView> {
  final OrderTrackingController _orderTrackingController = Get.put(OrderTrackingController());
  final OrderDetailsController _orderDetailsController = Get.put(OrderDetailsController());


  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _orderTrackingController.polylinePoints = PolylinePoints(apiKey: SKey.googleApiKey);
      // First initialize tracking to get initial data
      await _orderTrackingController.initializeTracking();
      // Then initialize socket for real-time updates
      _orderTrackingController.initSocket();
      await _orderDetailsController.fetchOrderDetails();

      print('App initialization completed');
    } catch (e) {
      print('Error during initialization: $e');
    }
  }

  @override
  void dispose() {
    _orderTrackingController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        ),
      ),
      body: Stack(
        children: [
          // Map layer with proper reactive updates
          Obx(() {
            // Get current locations from controller
            LatLng userLocation = _orderTrackingController.pickupLocation.value;
            LatLng driverLocation = _orderTrackingController.driverLocation.value;

            // Create markers set
            Set<Marker> markers = _buildMarkers(userLocation, driverLocation);

            // Create polylines set
            Set<Polyline> polylines = _buildPolylines();

            // Show loading indicator if locations are not available
            if (userLocation.latitude == 0 && userLocation.longitude == 0) {
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      Text('Loading map...'),
                    ],
                  ),
                ),
              );
            }

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation,
                zoom: 15,
              ),
              mapType: MapType.hybrid,
              polylines: polylines,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _orderTrackingController.setMapController(controller);
                print('Map created with controller');
              },
              padding: EdgeInsets.only(bottom: 150.h),
              myLocationEnabled: false, // Disable default location button
              compassEnabled: true,
              mapToolbarEnabled: false,
            );
          }),

          // Connection status indicator
          Obx(() => _orderTrackingController.connectionStatus.value != 'Connected'
              ? Positioned(
            top: 100.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    'Status: ${_orderTrackingController.connectionStatus.value}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
           ):SizedBox.shrink(),
          ),
          /// Draggable bottom sheet with order details
          Obx((){
            OrderData? orderDetailItems = _orderDetailsController.orderDetailResponse.value.data;
            return BottomSheetOrderDetails(orderDetailItems: orderDetailItems??OrderData(),);
          }),

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
                            imageUrl: AppConstants.mechanicImage,
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
                                Obx(() => Text(
                                  _orderTrackingController.trackingModel.value.mechanicId ?? 'Darrell Steward',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                )),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              // Add cancel order functionality
                              _showCancelDialog();
                            },
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
                  Row(
                    children: [
                      Expanded(
                        child: Obx((){
                        String? mechanicId = _orderTrackingController.trackingModel.value.mechanicId;
                          return  CustomButton(
                            onTap: () {
                              if(mechanicId !=null){
                                Get.toNamed(Routes.MESSAGEINBOX,arguments: {"receiverId": mechanicId});
                              }
                            },
                            text: 'Message',
                          );
                        }

                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomButton(
                          onTap: _refreshLocation,
                          text: 'Refresh',
                          color: Colors.grey[300],
                          textStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          // Bottom progress indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => ProgressBar(
              steps: ['Order Confirmed', 'Out For Pickup', 'Almost Done'],
              currentStep: _getProgressStep(),
             ),
            ),
          ),

          // Debug info (remove in production)
          if (kDebugMode)
            Positioned(
              top: 120.h,
              right: 16.w,
              child: Obx(() => Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location Info:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('User: ${_orderTrackingController.pickupLocation.value}', style: TextStyle(color: Colors.white, fontSize: 8.sp)),
                    Text('Driver: ${_orderTrackingController.driverLocation.value}', style: TextStyle(color: Colors.white, fontSize: 8.sp)),
                    Text('Polyline: ${_orderTrackingController.polylineCoordinates.length} points', style: TextStyle(color: Colors.white, fontSize: 8.sp)),
                  ],
                ),
              )),
            ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers(LatLng userLocation, LatLng driverLocation) {
    Set<Marker> markers = {};

    // Add user location marker
    if (userLocation.latitude != 0 && userLocation.longitude != 0) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: userLocation,
          infoWindow: InfoWindow(
              title: 'Your Location',
              snippet: 'Pickup point'
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add driver location marker
    if (driverLocation.latitude != 0 && driverLocation.longitude != 0) {
      markers.add(
        Marker(
          markerId: MarkerId('driver'),
          position: driverLocation,
          infoWindow: InfoWindow(
              title: 'Mechanic',
              snippet: 'Current location'
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_orderTrackingController.polylineCoordinates.isEmpty) {
      return {};
    }

    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: _orderTrackingController.polylineCoordinates,
        color: AppColors.primaryColor,
        width: 4,
        patterns: [PatternItem.dot, PatternItem.gap(10)],
      )
    };
  }

  void _refreshLocation() async {
    try {
      await _orderTrackingController.fetchRoutePolyline();
      Get.snackbar(
        'Success',
        'Location refreshed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh location',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  void _showCancelDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Cancel Order'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Add cancel order logic here
              Get.back();
              Get.snackbar('Cancelled', 'Order cancellation requested');
            },
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  int _getProgressStep() {
    String status = _orderTrackingController.trackingModel.value.status ?? '';
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 0;
      case 'pickup':
      case 'on_the_way':
        return 1;
      case 'almost_done':
      case 'arrived':
        return 2;
      default:
        return 0;
    }
  }
}