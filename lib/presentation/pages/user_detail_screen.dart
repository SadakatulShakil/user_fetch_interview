import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/user_model.dart';

class UserDetailPage extends StatelessWidget {
  final User user;
  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user.firstName} Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Hero(
                tag: user.id,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: CachedNetworkImageProvider(user.avatar),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${user.firstName} ${user.lastName}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            _infoTile(Icons.person, "User ID", "#${user.id}"),
            _infoTile(Icons.email, "Email", user.email),
            _infoTile(Icons.phone, "Phone", "Not Available (API limitation)"),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(title),
      ),
    );
  }
}