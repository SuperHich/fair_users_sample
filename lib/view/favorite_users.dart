import 'package:flutter/material.dart';
import 'package:fair_users/model/user.dart';

class FavoriteUsers extends StatefulWidget {
  final Set<User> savedUsers;
  const FavoriteUsers(this.savedUsers);

  @override
  _FavoriteUsersState createState() => _FavoriteUsersState();

}

class _FavoriteUsersState extends State<FavoriteUsers> {
  @override
  Widget build(BuildContext context) {
    final tiles = widget.savedUsers.map(
          (User user) {
        return ListTile(
          title: Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 18.0),
          ),
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles).toList()
        : <Widget>[];

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite users'),
      ),
      body: ListView(children: divided),
    );
  }
}