import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/data/google_api_service.dart';
import 'package:roadside_assistance/app/modules/my_location_selection/controllers/my_location_selection_controller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:roadside_assistance/common/widgets/custom_search_field.dart';

class MapLocationView extends StatefulWidget {
  const MapLocationView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapLocationView> {
  final MyLocationSelectionController _locationSelectionCtrl = Get.put(MyLocationSelectionController());
  late final TextEditingController searchLocationCtrl = TextEditingController();

  GoogleMapController? mapController;
  final LatLng center = const LatLng(19.432608, -99.133209); // Default to Mexico City
  LatLng? pickedLocation;
  List<String> onChangeTextFieldValue = [];
  BitmapDescriptor? customIcon;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      customIcon = await bitmapDescriptorFromSvgAsset();
      }
    );
  }

  /// convert svg to bitmap
  Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset([Size size = const Size(20, 20),]) async {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader('assets/icons/map_pin.svg'), null);

    double devicePixelRatio = ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    int width = (size.width * devicePixelRatio).toInt();
    int height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return BitmapDescriptor.bytes(bytes.buffer.asUint8List());
  }
 /// My current location
  getMyCurrentLocation() async{
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

  /// Api Call method
  void confirmLocation(String selectedLocation) {
    // You can make an API call here to save the selected location or perform other actions
    final args = Get.arguments ?? {};
    print(selectedLocation);
    if(args['from']=='login'){
      //Get.toNamed(Routes.SIGN_UP, arguments: {'latLng': _pickedLocation});
    }else{
      //Get.offAndToNamed(Routes.HOME);
    }
    print("Location confirmed: $pickedLocation");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Google Map view
          Positioned.fill(
            child: SafeArea(
              child: GoogleMap(
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 11.0,
                ),
                onTap: (position) {
                  moveCamera(position);
                },
                myLocationEnabled: true,
                markers: {
                  if (pickedLocation != null)
                    Marker(
                      markerId: MarkerId(pickedLocation.toString()),
                      draggable: true,
                      icon: customIcon!,
                      position: pickedLocation!,
                      onDragEnd: (newPosition) {
                        _locationSelectionCtrl.pickedNewLocation = newPosition;
                        print('New position: ${_locationSelectionCtrl.pickedNewLocation}');
                      },
                    ),
                },

              )
            ),
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
              height: 80.h,
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

          /// Location Suggesion List
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

          /// Confirm button at the bottom
          Positioned(
            bottom: 30.h,
            left: 15.w,
            right: 15.w,
            child: CustomButton(
              onTap: () {
                if(pickedLocation != null){
                  _locationSelectionCtrl.pickedNewLocation = pickedLocation;
                  _locationSelectionCtrl.pickupLocationCtrl.text = searchLocationCtrl.text;
                  Get.back(result: pickedLocation);
                  confirmLocation(searchLocationCtrl.text);
                  print(_locationSelectionCtrl.pickedNewLocation);
                  Get.snackbar('Successfully selected', _locationSelectionCtrl.pickupLocationCtrl.text);
                }else {
                  print("No location selected!");
                  Get.snackbar('No location selected!', 'Please select your location ');
                }
              },
              text: 'Confirm Location',
              height: 54.h,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

