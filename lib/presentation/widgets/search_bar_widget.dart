import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_task/presentation/controllers/user_controller.dart';


class UserSearchBar extends StatelessWidget{
  final UserController controller;

  const UserSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        focusNode: controller.searchFocusNode,
        onChanged: controller.onSearchChanged, // Use the new method
        decoration: InputDecoration(
          hintText: "Search by name or email...",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade600),

          // --- Dynamic Clear Icon ---
          suffixIcon: controller.searchText.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
            onPressed: controller.clearSearch,
          )
              : null,

          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    ));
  }
}