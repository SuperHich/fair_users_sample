import 'dart:convert';

import 'package:fair_users/model/user.dart';
import 'package:fair_users/model/user_response.dart';
import 'package:http/http.dart' as http;

Future<UserResponse> fetchUsers() async {
  final response = await http.get(
      Uri.parse('https://dummyapi.io/data/api/user?limit=100'),
      headers: {'app-id' : "6104543c1dc6e68fe34f31d4"}
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return UserResponse.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load users');
  }
}

Future<User> fetchUserDetails(String userId) async {
  final response = await http.get(
      Uri.parse('https://dummyapi.io/data/api/user/$userId'),
      headers: {'app-id' : "6104543c1dc6e68fe34f31d4"}
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user details');
  }
}