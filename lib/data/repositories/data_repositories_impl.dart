import 'dart:convert';
import 'dart:io';
import 'dart:async'; // Added for TimeoutException
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:interview_task/data/repositories/user_repositories.dart';
import '../models/hive_data_model.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final http.Client client;
  final Box<UserModel> userBox;
  final Connectivity connectivity;

  UserRepositoryImpl({
    required this.client,
    required this.userBox,
    required this.connectivity,
  });

  @override
  Future<List<UserModel>> getUsers(int page) async {
    // 1. Check Connectivity
    var connectivityResult = await connectivity.checkConnectivity();
    bool hasNetworkInterface = connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    bool hasInternetAccess = false;
    if (hasNetworkInterface) {
      try {
        final result = await InternetAddress.lookup('google.com');
        hasInternetAccess = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        hasInternetAccess = false;
      }
    }

    print("🔍 Network Interface: $hasNetworkInterface, Internet Access: $hasInternetAccess");

    if (hasInternetAccess) {
      try {
        print("🌍 Attempting API call for page $page...");

        // Note: JSONPlaceholder uses _page and _limit
        final response = await client.get(
          Uri.parse('https://jsonplaceholder.typicode.com/users?_page=$page&_limit=6'),
          headers: {
            'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          // FIXED LINE: Decode as a List, not a Map
          final List<dynamic> usersJson = json.decode(response.body);

          List<UserModel> users = usersJson
              .map((json) => UserModel.fromJson(json))
              .toList();

          // Save to Hive (Cache)
          print("💾 Caching ${users.length} users to Hive...");
          if (page == 1) await userBox.clear();
          for (var user in users) {
            await userBox.put(user.id, user);
          }

          return users;
        } else {
          print("❌ Server Error: ${response.statusCode}. Trying local cache...");
          return _getLocalUsers();
        }
      } catch (e) {
        print("❌ API Failed. Error: $e");
        return _getLocalUsers();
      }
    } else {
      print("⚠️ No internet detected. Loading from cache.");
      return _getLocalUsers();
    }
  }

  List<UserModel> _getLocalUsers() {
    if (userBox.isEmpty) {
      print("📂 Cache is empty.");
      return []; // Return empty list instead of throwing Exception
    }
    print("📂 Loaded ${userBox.length} users from Hive.");
    return userBox.values.toList();
  }
}