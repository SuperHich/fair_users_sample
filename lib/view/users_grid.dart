import 'package:fair_users/model/user.dart';
import 'package:fair_users/utils/shared_data.dart';
import 'package:fair_users/view/user_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersGrid extends StatefulWidget {
  final List<User> users;
  final Set<User> saved;
  const UsersGrid(this.users, this.saved);

  _UsersGridState createState() => _UsersGridState();
}

class _UsersGridState extends State<UsersGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.users.length,
        itemBuilder: (context, i) {
          return _buildGridRow(widget.users[i]);
        });
  }

  Widget _buildGridRow(User user) {
    final alreadySaved = widget.saved.any((item) => item.id == user.id);
    return Card(
      child : InkWell(
        child: GridTile(
            child: Image.network(user.picture, fit: BoxFit.cover),
            header: Container(
              alignment: Alignment.topRight,
              child: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
              ),
            ),
            footer: Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    backgroundColor: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
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