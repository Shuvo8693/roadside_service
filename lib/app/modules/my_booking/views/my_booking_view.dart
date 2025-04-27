import 'package:flutter/material.dart';

import 'package:roadside_assistance/app/modules/my_booking/widgets/my_booking_card.dart';
import 'package:roadside_assistance/common/app_constant/app_constant.dart';
import 'package:roadside_assistance/common/bottom_menu/bottom_menu..dart';


class MyBookingView extends StatelessWidget {
  const MyBookingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 3,
          padding: EdgeInsets.all(10),
          itemBuilder: (context,index){
        return  MyBookingCard(
            name: 'Marley',
            title: 'Mechanic',
            rating: 2.5,
            imageUrl: AppConstants.mechanicImage,
            onTap: (){},
           status: 'completed',
        );
      }),
    );
  }
}
