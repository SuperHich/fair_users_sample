import 'dart:convert';

import 'package:fair_users/model/user.dart';
import 'package:http/http.dart' as http;

const String BASE_URL = "http://localhost:8080/";
const String HEADER_ACCEPT = "application/json; charset=UTF-8";

Future<List<User>> fetchUsers() async {
  final response = await http.get(
      Uri.parse('${BASE_URL}users'),
      headers: {
        "Accept": HEADER_ACCEPT,
        "Access-Control-Allow-Origin": "*"
      }
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
      Uri.parse('${BASE_URL}user/$userId'),
      headers: {"Accept": HEADER_ACCEPT}
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