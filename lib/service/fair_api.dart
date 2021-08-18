import 'dart:convert';

import 'package:fair_users/model/user.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response = await http.get(
      Uri.parse('http://localhost:8080/users'),
      headers: {"Accept": "application/json; charset=UTF-8"}
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var iterable = jsonDecode(response.body) as List;
    List<User> result = iterable.map((e) => User.fromJson(e)).toList();
    return result;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load users');
  }
}

Future<User> fetchUserDetails(String userId) async {
  final response = await http.get(
      Uri.parse('http://localhost:8080/user/$userId'),
      headers: {"Accept": "application/json; charset=UTF-8"}
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