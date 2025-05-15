import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleModel;
  final String vehicleBrand;
  final String vehicleNumber;
  final VoidCallback onDelete;

  const VehicleCard({
    super.key,
    required this.vehicleModel,
    required this.vehicleBrand,
    required this.vehicleNumber,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.grey.shade300, width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    label: 'Vehicle Model',
                    value: vehicleModel,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildInfoColumn(
                    label: 'Vehicle Brand',
                    value: vehicleBrand,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    label: 'Vehicle Number',
                    value: vehicleNumber,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24.r,
                  ),
                  iconSize: 24.r,
                  padding: EdgeInsets.all(8.r),
                  constraints: BoxConstraints(
                    minWidth: 40.r,
                    minHeight: 40.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}