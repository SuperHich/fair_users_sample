import 'dart:async';

import 'package:fair_users/model/user.dart';
import 'package:fair_users/service/fair_api.dart';
import 'package:fair_users/utils/shared_data.dart';
import 'package:fair_users/view/favorite_users.dart';
import 'package:fair_users/view/user_details.dart';
import 'package:fair_users/view/users_grid.dart';
import 'package:fair_users/view/users_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fair users',
      theme: ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.white,
      ),
      home: FairUsers(),
    );
  }
}

class FairUsers extends StatefulWidget {
  @override
  _FairUsersState createState() => _FairUsersState();
}

class _FairUsersState extends State<FairUsers> {
  late Future<List<User>> usersResponse;
  final _users = <User>[];
  final _saved = <User>{};

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() {
    setState(() {
      usersResponse = fetchUsers();
    });
  }

  void loadFavoriteUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedUserIds = prefs.getStringList(KEY_FAVORITE_USERS) ?? List.empty();
    if(savedUserIds.isNotEmpty) {
      List<User> usersList = _users.where((e) => savedUserIds.contains(e.id)).toList();
      setState(() {
          _saved.addAll(usersList);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fair users'),
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              onPressed: (){
                pushSaved(_saved);
              }
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "List",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_3x3),
              label: "Grid"
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[500],
        onTap: _onItemTapped,
      ),
      body: Center(
        child: FutureBuilder<List<User>>(
          future: usersResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              _users.clear();
              _users.addAll(snapshot.data!);

              loadFavoriteUsers();

              if(_selectedIndex == 0) {
                return UsersList(_users, _saved, _refreshUsers);
              } else {
                return UsersGrid(_users, _saved, _refreshUsers);
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void pushSaved(Set<User> savedUsers) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return FavoriteUsers(_saved);
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