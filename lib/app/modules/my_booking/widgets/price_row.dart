import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const PriceRow({super.key,
    required this.title,
    required this.amount,
    this.isTotal = false, // Default value for isTotal is false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
