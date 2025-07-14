import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mechanic_service_card.dart';

class AddedServicesTab extends StatefulWidget {
  final dynamic mechanicServiceController;
  final Function(dynamic) onRemoveService;

  const AddedServicesTab({
    super.key,
    required this.mechanicServiceController,
    required this.onRemoveService,
  });

  @override
  State<AddedServicesTab> createState() => _AddedServicesTabState();
}

class _AddedServicesTabState extends State<AddedServicesTab> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (widget.mechanicServiceController.addedServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No services added yet',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add services from the All Service tab',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: widget.mechanicServiceController.addedServices.length,
      itemBuilder: (context, index) {
        final service = widget.mechanicServiceController.addedServices[index];
        return MechanicServiceCard(
          service: service,
          isAddedService: true,
          removeOnTap: () {
            widget.onRemoveService(service);
          },
        );
      },
    );
  }
}