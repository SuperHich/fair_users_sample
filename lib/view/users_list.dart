import 'dart:convert';

import 'package:fair_users/model/user.dart';
import 'package:fair_users/utils/shared_data.dart';
import 'package:fair_users/view/user_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  final List<User> users;
  final Set<User> saved;
  const UsersList(this.users, this.saved);

  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.users.length,
        itemBuilder: (context, i) {
          return _buildRow(widget.users[i]);
        });
  }

  Widget _buildRow(User user) {
    final alreadySaved = widget.saved.any((item) => item.id == user.id);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.picture),
          radius: 30,
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontSize: 18.0),
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: (){
          pushDetails(user);
        },
        onLongPress: () {
          setState(() {
            if (alreadySaved) {
              widget.saved.remove(user);
            } else {
              widget.saved.add(user);
            }
            saveFavoriteUsers(widget.saved.toList());
          });
        },
      ),
    );
  }

  void pushDetails(User user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return UserDetails(user);
        },
      ),
    );
  }
}