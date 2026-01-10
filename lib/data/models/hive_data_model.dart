import 'package:hive/hive.dart';
import 'package:interview_task/data/models/user_model.dart';
part 'hive_data_model.g.dart';
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
    // RandomUser API structure mapping
    return UserModel(
      // Generate a stable integer ID from the email because the API's ID can be null
      id: json['email'].hashCode,
      email: json['email'] ?? '',
      firstName: json['name']['first'] ?? '',
      lastName: json['name']['last'] ?? '',
      avatar: json['picture']['large'] ?? '',
    );
  }
}