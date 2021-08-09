import 'package:fair_users/model/user.dart';

class UserResponse {
  final List<User> data;
  final int total;
  final int page;
  final int limit;
  final int offset;

  UserResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.offset,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<User> itemsList = list.map((i) => User.fromJson(i)).toList();
    return UserResponse(
      data: itemsList,
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}