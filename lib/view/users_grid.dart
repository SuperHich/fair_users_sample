import 'package:fair_users/model/user.dart';
import 'package:fair_users/utils/shared_data.dart';
import 'package:fair_users/view/user_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class UsersGrid extends StatefulWidget {
  final List<User> users;
  final Set<User> saved;
  final Function refreshUsers;
  const UsersGrid(this.users, this.saved, this.refreshUsers);

  _UsersGridState createState() => _UsersGridState();
}

class _UsersGridState extends State<UsersGrid> {

  static Interval opacityCurve = const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return RefreshIndicator(
      child : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.users.length,
          itemBuilder: (context, i) {
            return _buildGridRow(widget.users[i]);
          }),
      onRefresh: () => Future.delayed(
          Duration(seconds: 1),
              () {
            setState(() {
              widget.refreshUsers();
            });
          }),
    );
  }

  Widget _buildGridRow(User user) {
    final alreadySaved = widget.saved.any((item) => item.id == user.id);
    return Card(
      child : InkWell(
        child: GridTile(
            child: Hero(
              tag: user.id,
              child: Image.network(user.picture, fit: BoxFit.cover),
            ),
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
      PageRouteBuilder<void>(
        pageBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: opacityCurve.transform(animation.value),
                  child: UserDetails(user),
                );
              });
        },
      ),
    );
  }
}