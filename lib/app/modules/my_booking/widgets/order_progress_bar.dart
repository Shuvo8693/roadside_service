import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/common/widgets/spacing.dart';

class ProgressBar extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const ProgressBar({super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Container(
        color: Colors.white,
        height: 63.h,
        child: Row(
          children: List.generate(steps.length, (index) {
            bool isActive = index <= currentStep;
            bool isCompleted = index < currentStep;

            return Expanded(
              child: Padding(
                padding:  EdgeInsets.only(top: 8.h),
                child: Column(
                  children: [
                    /// Step Ball
                    Row(
                      children: [
                        horizontalSpacing(12.w),
                        CircleAvatar(
                          radius: 12.r,
                          backgroundColor: isCompleted ? Colors.green : ( isActive ? Colors.green[300] : Colors.grey[300]),
                          child: Icon(
                            isCompleted ? Icons.check : null,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        if (index < steps.length -1)
                          Expanded(
                            child: Divider(
                              color: isCompleted ? Colors.green : (isActive ? Colors.green[300] : Colors.grey),
                              thickness: 5,
                              endIndent: 0,
                              indent: 2,
                            ),
                          ),

                      ],
                    ),
                    SizedBox(height: 8),
                    /// Step label
                    Text(
                      steps[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted ? Colors.green : (isActive ? Colors.green[300] : Colors.grey),
                      ),
                    ),

                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}