import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/controllers/rating_review_controller.dart';
import 'package:roadside_assistance/common/widgets/custom_button.dart';

class ReviewRatingBottomSheet extends StatefulWidget {
  final String? orderId;

  const ReviewRatingBottomSheet({super.key, this.orderId});

  @override
  _ReviewRatingBottomSheetState createState() =>
      _ReviewRatingBottomSheetState();
}

class _ReviewRatingBottomSheetState extends State<ReviewRatingBottomSheet> {
  final RatingReviewController _ratingReviewController = Get.put(
    RatingReviewController(),
  );
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Text(
            'Leave a Review',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),

          // Rating Text
          Text(
            'Rating:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),

          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32.sp,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                  print(_rating);
                },
              );
            }),
          ),
          SizedBox(height: 16.h),

          // Review Text
          Text(
            'Review:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),

          // Review Text Field
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your review...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
          ),
          SizedBox(height: 20.h),

          // Action Buttons
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text('Cancel', style: TextStyle(fontSize: 16.sp)),
                ),
              ),
              SizedBox(width: 16.w),
              // Post Button
              Expanded(
                child: Obx((){
                  return CustomButton(
                    loading: _ratingReviewController.isLoading2.value,
                    width: double.infinity,
                    height: 50.h,
                    onTap: () async {
                    await _ratingReviewController.postReview(
                        review: Review(
                          order: widget.orderId,
                          rating: _rating,
                          comment: _reviewController.text,
                        ),
                        callBack: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    text: 'Post',
                  );
                }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
