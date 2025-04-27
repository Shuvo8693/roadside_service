import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';


class MyBookingCard extends StatelessWidget {
  final String name;
  final String title;
  final String status;
  final double rating;
  final String imageUrl;
  final VoidCallback onTap;

  const MyBookingCard({
    super.key,
    required this.name,
    required this.title,
    required this.rating,
    required this.imageUrl,
    required this.onTap,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Mechanic image
            CustomNetworkImage(
              imageUrl: imageUrl ?? '',
              boxShape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.r),
              height: 110.h,
              width: 100.h,
              boxFit: BoxFit.cover,
            ),
            SizedBox(width: 10.w),
            /// Mechanic info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Title and name
                  Text(
                    title,
                    style: GoogleFontStyles.h5(
                      color: Colors.grey,
                      fontSize: 12.sp, // Using ScreenUtil to scale font size
                    ),
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    style: GoogleFontStyles.h4(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  /// Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryColor,
                        size: 18.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text('$rating/5',
                        style: GoogleFontStyles.h5(
                          color: AppColors.primaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  /// View button and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 6,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Container(
                            height: 16.h,
                            width: 16.h,
                            decoration: BoxDecoration(
                              color: status=='pending'? Colors.amber : status=='cancelled'? Colors.red :status=='completed'? AppColors.green: Colors.grey,
                               borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          Text(status,style: GoogleFontStyles.h5(),),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      TextButton(
                        onPressed: onTap,
                        child: Text('View Details',style: GoogleFontStyles.h4(),),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}