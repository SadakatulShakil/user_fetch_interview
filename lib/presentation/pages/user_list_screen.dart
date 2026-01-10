import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:interview_task/presentation/pages/user_detail_screen.dart';
import '../controllers/user_controller.dart';

class UserListPage extends GetView<UserController> {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sokrio User List")),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.filterUsers,
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // --- User List ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.errorMessage.value),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: controller.loadUsers,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                );
              }

              if (controller.displayUsers.isEmpty) {
                return const Center(child: Text("No users found."));
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.separated(
                  controller: controller.scrollController,
                  itemCount: controller.displayUsers.length + 1,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    // Pagination Loader at bottom
                    if (index == controller.displayUsers.length) {
                      return controller.isPaginationLoading.value
                          ? const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
                          : const SizedBox.shrink();
                    }

                    final user = controller.displayUsers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Hero(
                        tag: user.id,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(user.avatar),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      title: Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user.email),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.to(() => UserDetailPage(user: user) ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}