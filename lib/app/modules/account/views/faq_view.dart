import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  final List<Map<String, String>> faqData = const [
    {
      'question': 'What is AfroBase?',
      'answer':
      'AfroBase is a multivendor marketplace that connects buyers and sellers, offering a wide range of products and services. Our platform is designed to empower local vendors while providing buyers with a seamless shopping experience.'
    },
    {
      'question': 'What services do you offer?',
      'answer': 'Details about services will be provided here.'
    },
    {
      'question': 'What services do you offer?',
      'answer': 'Details about services will be provided here.'
    },
    {
      'question': 'How do I create an account on AfroBase?',
      'answer': 'Step-by-step guide to create an account will be here.'
    },
    {
      'question': 'How can I sell on AfroBase?',
      'answer': 'Instructions for selling on AfroBase will be here.'
    },
    {
      'question': 'What payment methods are accepted on AfroBase?',
      'answer': 'Information about accepted payment methods will be here.'
    },
    {
      'question': 'Is shopping on AfroBase safe?',
      'answer': 'Details about safety measures will be here.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently asked questions?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
             SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: faqData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:  EdgeInsets.only(bottom: 12.0.h),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ExpansionTile(
                      maintainState: true,
                      shape: Border(top: BorderSide.none),
                      title: Text(
                        faqData[index]['question']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(16.0.sp),
                          child: Text(
                            faqData[index]['answer']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                      tilePadding:
                       EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                      childrenPadding:  EdgeInsets.only(bottom: 8.0.h),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}