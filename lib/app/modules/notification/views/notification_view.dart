import 'package:flutter/material.dart';
import 'package:roadside_assistance/app/modules/notification/widgets/notification_card.dart';

class NotificationView extends StatefulWidget {
   const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  // Mock Data for ListTile items
  final List<Map<String, String>> notifications = [
    {
      'image': 'assets/images/sample1.png',
      'title': 'New Message from John',
      'subtitle': 'Hey, how are you?',
      'time': '2 min ago',
    },
    {
      'image': 'assets/images/sample2.png',
      'title': 'System Update Available',
      'subtitle': 'Please update your app',
      'time': '5 min ago',
    },
    {
      'image': 'assets/images/sample3.png',
      'title': 'New Follower: Jane',
      'subtitle': 'Jane started following you.',
      'time': '1 hour ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationTile(
            onTap: (){},
            image: notifications[index]['image']!,
            title: notifications[index]['title']!,
            subtitle: notifications[index]['subtitle']!,
            time: notifications[index]['time']!,
          );
        },
      ),
    );
  }
}

