import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:interview_task/presentation/pages/user_list_screen.dart';

import 'data/models/hive_data_model.dart';
import 'data/models/user_model.dart';
import 'data/networks/network_info.dart';
import 'data/repositories/data_repositories_impl.dart';
import 'presentation/controllers/user_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter()); // Auto-generated
  var box = await Hive.openBox<UserModel>('users_cache');

  runApp(MyApp(userBox: box));
}

class MyApp extends StatelessWidget {
  final Box<UserModel> userBox;
  const MyApp({super.key, required this.userBox});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sokrio Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialBinding: AppBinding(userBox), // Inject dependencies
      home: const UserListPage(),
    );
  }
}

// Dependency Injection Setup
class AppBinding extends Bindings {
  final Box<UserModel> userBox;
  AppBinding(this.userBox);

  @override
  void dependencies() {
    // Services
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: Get.find()));
    Get.lazyPut(() => http.Client());
    Get.lazyPut(() => Connectivity());

    // Repository
    Get.lazyPut(() => UserRepositoryImpl(
      client: Get.find(),
      userBox: userBox,
      connectivity: Get.find(),
    ));

    // Controller
    Get.lazyPut(() => UserController(repository: Get.find<UserRepositoryImpl>()));
  }
}