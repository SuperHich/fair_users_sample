
import 'package:fair_users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String KEY_FAVORITE_USERS = "favorite_users";

void saveFavoriteUsers(List<User> users) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> userIds = users.map((e) => e.id).toList();
  prefs.setStringList(KEY_FAVORITE_USERS, userIds);
}