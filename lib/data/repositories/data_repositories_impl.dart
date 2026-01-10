import 'dart:convert';
import 'dart:io'; // Needed for InternetAddress
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:interview_task/data/repositories/user_repositories.dart'; // Adjust path if needed
import '../models/user_model.dart';
import '../models/hive_data_model.dart'; // Ensure User entity is imported here

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
  Future<List<User>> getUsers(int page) async {
    // 1. Check if connected to a Network Interface (WiFi/Mobile)
    var connectivityResult = await connectivity.checkConnectivity();
    bool hasNetworkInterface = connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    // 2. Check for ACTUAL Internet Access
    bool hasInternetAccess = false;
    if (hasNetworkInterface) {
      try {
        final result = await InternetAddress.lookup('google.com');
        hasInternetAccess = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        hasInternetAccess = false;
      }
    }

    if (hasInternetAccess) {
      try {
        print("🌍 Attempting API call for page $page...");

        final response = await client.get(
          Uri.parse('https://reqres.in/api/users?page=$page&per_page=10'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List usersJson = data['data'];

          List<UserModel> users = usersJson
              .map((json) => UserModel.fromJson(json))
              .toList();

          // 3. Save to Hive (Cache)
          print("💾 Caching ${users.length} users to Hive...");
          for (var user in users) {
            await userBox.put(user.id, user);
          }

          return users;
        } else {
          throw Exception('Server returned status: ${response.statusCode}');
        }
      } catch (e) {
        // 🔴 THIS PRINT IS CRITICAL TO DEBUGGING
        print("❌ API Failed despite having internet. Error: $e");

        // Fallback to local if API fails
        return _getLocalUsers();
      }
    } else {
      print("⚠️ No real internet access detected. Loading from cache.");
      return _getLocalUsers();
    }
  }

  List<User> _getLocalUsers() {
    if (userBox.isEmpty) {
      // Throwing exception here allows the Controller to show "No Data" message
      throw Exception('No internet and no local data.');
    }
    print("📂 Loaded ${userBox.length} users from Hive.");
    return userBox.values.toList();
  }
}