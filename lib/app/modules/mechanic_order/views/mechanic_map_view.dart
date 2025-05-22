import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/sk_key.dart';

class MechanicMapView extends StatefulWidget {
  const MechanicMapView({super.key});

  @override
  State<MechanicMapView> createState() => _MechanicMapViewState();
}

class _MechanicMapViewState extends State<MechanicMapView> {
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
        ],
      ),
    );
  }
}






