import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/modules/mechanic_service/views/mechanic_service_view.dart';
import 'package:roadside_assistance/common/app_icons/app_icons.dart';

class MechanicServiceController extends GetxController {
  final List<ServiceItem> addedServices = [];
  final List<ServiceItem> allServices = [
    ServiceItem(
      name: 'Towing',
      icon: AppIcons.towingIcon,
      price: 100,
      iconColor: Colors.blue,
    ),
    ServiceItem(
      name: 'Lockout',
      icon: AppIcons.lockoutIcon,
      price: 100,
      iconColor: Colors.orange,
    ),
    ServiceItem(
      name: 'Flat Tire\nRepair',
      icon: AppIcons.flatTireIcon,
      price: 100,
      iconColor: Colors.blue,
    ),
    ServiceItem(
      name: 'Gasoline\nDelivery',
      icon: AppIcons.gasolineIcon,
      price: 100,
      iconColor: Colors.blue,
    ),
    ServiceItem(
      name: 'Jump Start\nService',
      icon: AppIcons.jumpStartServiceIcon,
      price: 100,
      iconColor: Colors.orange,
    ),
  ];


}
