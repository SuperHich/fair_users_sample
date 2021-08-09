import 'package:fair_users/model/location.dart';

class User {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String picture;
  final String? gender;
  final String? phone;
  final DateTime? dateOfBirth;
  final Location? location;

  User({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.picture,
    required this.gender,
    required this.phone,
    required this.dateOfBirth,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      picture: json['picture'],
      gender: json['gender'] == null ? null : json['gender'],
      phone: json['phone'] == null ? null : json['phone'],
      dateOfBirth: json['dateOfBirth'] == null ? null : DateTime.parse(json['dateOfBirth']),
      location: json['location'] == null ? null : Location.fromJson(json['location']),
    );
  }
}