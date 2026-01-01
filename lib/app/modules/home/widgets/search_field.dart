import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Service Provider',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.blue),
        ),
      ),
    );
  }
}