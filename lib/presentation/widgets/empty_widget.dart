import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_rounded, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("No users found", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
