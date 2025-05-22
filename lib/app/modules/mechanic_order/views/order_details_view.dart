import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/modules/my_location_selection/controllers/my_location_selection_controller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart' show AppColors;
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final MyLocationSelectionController _locationSelectionCtrl = Get.put(MyLocationSelectionController());

  GoogleMapController? mapController;

  final LatLng center = const LatLng(25.432608, -80.133209);
  LatLng? currentLocation;
  List<String> onChangeTextFieldValue = [];
  BitmapDescriptor? customIcon;

  void moveCamera(LatLng target) {
    currentLocation = target;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15),
      ),
    );
    setState(() {});
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if(_locationSelectionCtrl.pickedNewLocation!=null){
      mapController?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: _locationSelectionCtrl.pickedNewLocation!))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// todo  ================================ Refactor Needed ===================================
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Order Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request ID
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request ID #878204',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Customer Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sarah Johnson',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'sarah@gmail.com',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        width: 100.w,
                          height: 45.h,
                          onTap: (){
                          Get.toNamed(Routes.MESSAGEINBOX);
                          }, text: 'Message'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            ///===== Vehicle Details ====
            _buildSection(
              title: 'Vehicle Details',
              child: Column(
                children: [
                  _buildDetailRow('Make', 'Toyota'),
                  SizedBox(height: 12.h),
                  _buildDetailRow('Model', 'Grace'),
                  SizedBox(height: 12.h),
                  _buildDetailRow('Year', '2017'),
                  SizedBox(height: 12.h),
                  _buildDetailRow('License Plate', '232-45'),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            ///==== Location ========
            _buildSection(
              title: 'Location',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async {
                      final result = await Get.toNamed(Routes.MECHANIC_MAP);
                      if (result != null && result is LatLng) {
                        setState(() {
                          currentLocation = result; // Update local state
                          _locationSelectionCtrl.pickedNewLocation = result;
                        });
                        moveCamera(result); // Move map to new location
                      }
                    },
                    child: Text(
                      'View map',
                      style: GoogleFontStyles.h4(color: AppColors.primaryColor),
                    ),
                  ),
                  Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Stack(
                      children: [
                        // Map placeholder
                        Container(
                          height: 200.h,
                          color: Colors.grey[300],
                          child: Center(
                            child: GoogleMap(
                              zoomControlsEnabled: false,
                             // myLocationButtonEnabled: true,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: currentLocation ?? center,
                                zoom: currentLocation != null ? 15.0 : 11.0,
                              ),
                              onTap: (position) {
                               // moveCamera(position);
                              },
                             // myLocationEnabled: true,
                              markers: {
                                if (currentLocation != null)
                                  Marker(
                                    markerId: MarkerId(currentLocation.toString()),
                                    position: currentLocation!,
                                    onDragEnd: (newPosition) {
                                      print('New position: $newPosition');
                                      moveCamera(newPosition);
                                    },
                                  ),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Pickup Location',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Est arrival: 15 mins (2.5 km away)',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Horsebag kellan somity\nStreet 256 Nica 5ea RD Dhaka',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Service Details
            _buildSection(
              title: 'Service Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Service Type', 'Flat Tire Repair'),
                  SizedBox(height: 12.h),
                  Text(
                    'Customer Notes',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Left rear tire is completely flat',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}