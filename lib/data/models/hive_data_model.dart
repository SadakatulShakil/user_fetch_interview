import 'package:hive/hive.dart';
import 'package:interview_task/data/models/user_model.dart';
part 'hive_data_model.g.dart'; // Ensure this matches your filename

@HiveType(typeId: 0)
class UserModel extends User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  }) : super(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    avatar: avatar,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 1. JSONPlaceholder provides a single "name" string (e.g., "Leanne Graham")
    String fullNames = json['name'] ?? 'Unknown User';
    List<String> nameParts = fullNames.split(' ');

    String fName = nameParts.isNotEmpty ? nameParts[0] : 'First';
    // Join the rest of the parts as the last name (handles names like "John Van Doe")
    String lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Last';

    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: fName,
      lastName: lName,
      // 2. JSONPlaceholder has no avatar, so we use a free service like Pravatar or UI-Avatars
      // This generates a unique, consistent image based on the User ID
      avatar: 'https://i.pravatar.cc/150?u=${json['id']}',
    );
  }
}