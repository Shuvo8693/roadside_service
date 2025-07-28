import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/controllers/rating_review_controller.dart';
import 'package:roadside_assistance/app/modules/mechanic_user_side/widgets/review_card.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/custom_appBar_title.dart';
import 'package:roadside_assistance/common/widgets/custom_page_loading.dart';

class RatingAndReviewView extends StatefulWidget {
  const RatingAndReviewView({super.key});

  @override
  State<RatingAndReviewView> createState() => _RatingAndReviewViewState();
}

class _RatingAndReviewViewState extends State<RatingAndReviewView> {
  final RatingReviewController _ratingReviewController = Get.put(RatingReviewController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      _ratingReviewController.fetchReview();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rating'),centerTitle: true,),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
        child: Column(
          children: [
            // Tabs
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     _buildTab('ALL', true),
            //     const SizedBox(width: 8),
            //     _buildTab('NEW', false),
            //     const SizedBox(width: 8),
            //     _buildTab('4+', false),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // Review List
            Expanded(
              child: Obx((){
               final reviewItemsList = _ratingReviewController.reviewResponse.value.data?.reviews??[];
               if(_ratingReviewController.isLoading.value){
                 return Center(child: CustomPageLoading());
               }else if(reviewItemsList.isEmpty){
                 return Center(child: Text('Reviews is empty'));
               }
                return ListView(
                  children:  [
                    ...List.generate(reviewItemsList.length, (int index){
                     final reviewItem = reviewItemsList[index];
                      return ReviewCard(
                        userName: reviewItem.user?.name??'',
                        date: '24th September, 2023',
                        rating: reviewItem.rating??0,
                        reviewText: reviewItem.comment??'',
                        imageUrl: reviewItem.user?.image??'',
                      );
                    })
                  ],
                );
               }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

