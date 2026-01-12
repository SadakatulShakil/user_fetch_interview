import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_task/presentation/controllers/user_controller.dart';

class CustomErrorWidget extends StatelessWidget {
  final UserController controller;
  const CustomErrorWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 60, color: Colors.red.shade200),
          const SizedBox(height: 16),
          Text(controller.errorMessage.value),
          TextButton(onPressed: controller.loadUsers, child: const Text("Try Again")),
        ],
      ),
    );
  }
}