import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repositories.dart';


class UserController extends GetxController {
  final UserRepository repository;
  UserController({required this.repository});

  // Observables
  var users = <User>[].obs;           // All loaded users
  var displayUsers = <User>[].obs;    // Users currently shown (filtered)
  var isLoading = true.obs;
  var isPaginationLoading = false.obs;
  var errorMessage = ''.obs;

  // Pagination Variables
  int currentPage = 1;
  bool hasMoreData = true;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUsers();

    // Listen for scroll to bottom
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent &&
          !isPaginationLoading.value &&
          hasMoreData) {
        loadMoreUsers();
      }
    });
  }

  // 1. Initial Load
  Future<void> loadUsers() async {
    try {
      isLoading(true);
      errorMessage('');
      var fetchedUsers = await repository.getUsers(1);

      users.assignAll(fetchedUsers);
      displayUsers.assignAll(fetchedUsers);
      currentPage = 1;
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // 2. Load More (Pagination)
  void loadMoreUsers() async {
    try {
      isPaginationLoading(true);
      int nextPage = currentPage + 1;
      var newUsers = await repository.getUsers(nextPage);

      if (newUsers.isEmpty) {
        hasMoreData = false;
      } else {
        // Add only unique users
        final existingIds = users.map((u) => u.id).toSet();
        final uniqueNewUsers = newUsers.where((u) => !existingIds.contains(u.id));

        users.addAll(uniqueNewUsers);

        // Refresh display list based on current search
        filterUsers(searchController.text);

        currentPage = nextPage;
      }
    } catch (e) {
      Get.snackbar("Notice", "Could not load more users");
    } finally {
      isPaginationLoading(false);
    }
  }

  // 3. Search Logic (Local Filter)
  void filterUsers(String query) {
    if (query.isEmpty) {
      displayUsers.assignAll(users);
    } else {
      displayUsers.assignAll(users.where((user) {
        return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

  // 4. Pull to Refresh
  Future<void> refreshData() async {
    hasMoreData = true;
    currentPage = 1;
    searchController.clear();
    await loadUsers();
  }
}