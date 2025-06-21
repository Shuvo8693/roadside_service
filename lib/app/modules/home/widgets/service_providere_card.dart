import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/app_text_style/google_app_style.dart';
import 'package:roadside_assistance/common/widgets/casess_network_image.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

class ServiceProviderCard extends StatelessWidget {
  final String name;
  final String title;
  final double rating;
  final String distance;
  final String duration;
  final String imageUrl;
  final bool isFavourite;
  final VoidCallback onTap;

  const ServiceProviderCard({
    super.key,
    required this.name,
    required this.title,
    required this.rating,
    required this.distance,
    required this.duration,
    required this.imageUrl,
    required this.onTap,
    this.isFavourite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
              height: 90.h,
              width: 85.h,
              boxFit: BoxFit.cover,
            ),
            SizedBox(width: 10.w),

            /// Mechanic info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: GoogleFontStyles.h4(fontWeight: FontWeight.bold),
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
                      Text(
                        '$rating/5',
                        style: GoogleFontStyles.h5(
                          color: AppColors.primaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  /// Distance and time
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        distance,
                        style: GoogleFontStyles.h5(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(Icons.access_time, color: Colors.grey, size: 16.sp),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          duration,
                          maxLines: 1,
                          style: GoogleFontStyles.h5(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // View button
            Column(
              children: [
                verticalSpacing(6.h),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    isFavourite
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: AppColors.primaryColor,
                    size: 28.h,
                  ),
                ),
                verticalSpacing(15.h),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    'Details',
                    style: GoogleFontStyles.h3(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
