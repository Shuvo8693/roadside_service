import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/modules/my_location_selection/controllers/my_location_selection_controller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/Alert_dialouge/thank_you_dialouge.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/custom_text_field.dart';
import 'package:roadside_assistance/common/widgets/success_alertdialog.dart';
import 'package:roadside_assistance/common/widgets/urbanist_font.dart';

class CheckoutSignupView extends StatefulWidget {

  const CheckoutSignupView({super.key});

  @override
  State<CheckoutSignupView> createState() => _CheckoutSignupViewState();
}

class _CheckoutSignupViewState extends State<CheckoutSignupView> {
  final MyLocationSelectionController _locationSelectionCtrl = Get.put(MyLocationSelectionController());
  final TextEditingController _pickupAddressCtrl = TextEditingController();
  final TextEditingController _streetNoCtrl = TextEditingController();
  final TextEditingController _vehicleModelCtrl = TextEditingController();
  final TextEditingController _vehicleBrandCtrl = TextEditingController();
  final TextEditingController _vehicleNumberCtrl = TextEditingController();
  final TextEditingController _additionalNoteCtrl = TextEditingController();

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
  void initState() {
    super.initState();
    currentLocation = _locationSelectionCtrl.pickedNewLocation;
    print('Checking location :${_locationSelectionCtrl.pickedNewLocation}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: ListView(
       padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: [
          const Text(
            'ADDRESS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          //  SizedBox(height: 8.h),
          // CustomTextButtonWithIcon(
          //   padding: EdgeInsets.symmetric(horizontal: 0),
          //   width: 200,
          //   height: 35,
          //   onTap: () {},
          //   icon: const Icon(Icons.location_on, color: Colors.blue),
          //   text: 'Use my current location',
          // ),
           SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'Set on map',
                style: GoogleFontStyles.h4(),
              ),
              TextButton(
                onPressed: () async {
                final result = await Get.toNamed(Routes.MAP);
                  if (result != null && result is LatLng) {
                    setState(() {
                      currentLocation = result; // Update local state
                      _locationSelectionCtrl.pickedNewLocation = result;
                      _pickupAddressCtrl.text  = _locationSelectionCtrl.pickupLocationCtrl.text;
                    });
                    moveCamera(result); // Move map to new location
                  }
                },
                child: Text(
                  'View map',
                  style: GoogleFontStyles.h4(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
           SizedBox(height: 8.h),
           /// Map Placeholder
          Container(
            height: 200.h,
            color: Colors.grey[300],
            child: Center(
              child: GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: currentLocation ?? center,
                  zoom: currentLocation != null ? 15.0 : 11.0,
                ),
                onTap: (position) {
                  moveCamera(position);
                },
                myLocationEnabled: true,
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

           SizedBox(height: 16.h),
          const Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8.h),
           /// Address Fields
          buildCustomTextField(
            hintText: 'Enter Pickup Address',
            controller: _pickupAddressCtrl,
          ),
           SizedBox(height: 8.h),
          const Text(
            'Street no',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8.h),
          buildCustomTextField(
            hintText: 'Street No',
            controller: _streetNoCtrl,
          ),
           SizedBox(height: 16.h),
           /// Vehicle Model
          const Text(
            'Vehicle Model',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
           SizedBox(height: 8.h),
          buildCustomTextField(
            hintText: 'Enter Vehicle Model',
            controller: _vehicleModelCtrl,
          ),
           SizedBox(height: 16.h),
           /// Vehicle Brand
          const Text(
            'Vehicle Brand',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
           SizedBox(height: 8.h),
          buildCustomTextField(
            hintText: 'Enter Vehicle Brand',
            controller: _vehicleBrandCtrl,
          ),
           SizedBox(height: 16.h),
           /// Vehicle Number
          const Text(
            'Vehicle Number',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
           SizedBox(height: 8.h),
          buildCustomTextField(
            hintText: 'Enter Vehicle number',
            controller: _vehicleNumberCtrl,
          ),
           SizedBox(height: 16.h),
           /// Save Vehicle Button
          CustomButton(
            width: 150.w,
              onTap: (){}, text: 'Save vehicle'),
           SizedBox(height: 16.h),
           /// Vehicle Selection (Radio Button)
          ListTile(
            leading: Radio(
              value: 1,
              groupValue: 1,
              onChanged: (value) {},
            ),
            title: const Text('Maruti Car (Suzuki)'),
            subtitle: const Text('2333-332'),
          ),
           SizedBox(height: 16.h),
           /// Additional Note
          const Text(
            'Additional Note',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
           SizedBox(height: 8.h),
          buildCustomTextField(
            hintText: 'Type here...',
            controller: _additionalNoteCtrl,
            maxLines: 3,
          ),
           SizedBox(height: 16.h),
           /// Book Button
      CustomButton(
          onTap: (){
            ThankYouDialog.show(context);
          }, text: 'Book'),
        ],
      ),
    );
  }

  Widget buildCustomTextField({
    required String hintText,
    required TextEditingController controller,
    int? maxLines = 1,
  }) {
    return CustomTextField(
      hintText: hintText,
      contentPaddingVertical: 16.h,
      controller: controller,
      maxLine: maxLines,
    );
  }

}