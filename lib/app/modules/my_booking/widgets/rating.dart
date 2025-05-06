import 'package:flutter/material.dart';

class ReviewRatingDialog extends StatefulWidget {
  const ReviewRatingDialog({super.key});

  @override
  _ReviewRatingDialogState createState() => _ReviewRatingDialogState();
}

class _ReviewRatingDialogState extends State<ReviewRatingDialog> {
  double _rating = 0.0;  // Track the rating (0-5)
  final TextEditingController _reviewController = TextEditingController();  // For review input

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Leave a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Text
          Text(
            'Rating:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          // Rating Stars Row (using IconButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),
          SizedBox(height: 16),

          // Review Text
          Text(
            'Review:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _reviewController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your review...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        // Post Button
        ElevatedButton(
          onPressed: () {
            // Handle Post logic if needed
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: Text('Post'),
        ),
      ],
    );
  }
}
