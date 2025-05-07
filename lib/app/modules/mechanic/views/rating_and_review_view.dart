import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/modules/mechanic/widgets/review_card.dart';
import 'package:roadside_assistance/common/app_color/app_colors.dart';
import 'package:roadside_assistance/common/widgets/custom_appBar_title.dart';

class RatingAndReviewView extends StatelessWidget {
  const RatingAndReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rating'),centerTitle: true,),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
        child: Column(
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTab('ALL', true),
                const SizedBox(width: 8),
                _buildTab('NEW', false),
                const SizedBox(width: 8),
                _buildTab('4+', false),
              ],
            ),
            const SizedBox(height: 16),
            // Review List
            Expanded(
              child: ListView(
                children:  [
                  ReviewCard(
                    userName: 'St Glix',
                    date: '24th September, 2023',
                    rating: 5,
                    reviewText:
                    'The positive aspect was undoubtedly the efficiency of the service. The queue moved quickly, the staff was friendly, and the food was up to the usual McDonald\'s standard – hot and satisfying.',
                  ),
                  SizedBox(height: 16.h),
                  ReviewCard(
                    userName: 'St Glix',
                    date: '24th September, 2023',
                    rating: 5,
                    reviewText:
                    'The positive aspect was undoubtedly the efficiency of the service. The queue moved quickly, the staff was friendly, and the food was up to the usual McDonald\'s standard – hot and satisfying.',
                  ),
                ],
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

