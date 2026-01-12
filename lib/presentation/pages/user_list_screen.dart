import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:interview_task/presentation/pages/user_detail_screen.dart';
import 'package:interview_task/presentation/widgets/error_widget.dart';
import '../controllers/user_controller.dart';
import '../widgets/empty_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/user_card_widget.dart';

class UserListPage extends GetView<UserController> {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBg = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          edgeOffset: 120, // Offset to show below the search bar
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              // --- Modern Collapsible AppBar ---
              SliverAppBar(
                expandedHeight: 140.0,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: scaffoldBg,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 65),
                  title: const Text(
                    "Sokrio Team",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                // --- Modern Floating Search Bar ---
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: UserSearchBar(controller: controller,),
                  ),
                ),
              ),

              // --- List Section ---
              Obx(() {
                if (controller.isLoading.value &&
                    controller.displayUsers.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return SliverFillRemaining(child: CustomErrorWidget(controller: controller));
                }

                if (controller.displayUsers.isEmpty) {
                  return SliverFillRemaining(child: EmptyWidget());
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index == controller.displayUsers.length) {
                          return _buildPaginationLoader();
                        }

                        final user = controller.displayUsers[index];
                        return UserCard(user: user, onTap: () {
                          controller.searchFocusNode.unfocus();
                          controller.clearSearch();
                          Get.to(() => UserDetailPage(user: user));
                        });
                      },
                      childCount: controller.displayUsers.length + 1,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationLoader() {
    return Obx(() => controller.isPaginationLoading.value
        ? const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator.adaptive()),
    )
        : const SizedBox(height: 50));
  }

}