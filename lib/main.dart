import 'dart:async';

import 'package:fair_users/model/user.dart';
import 'package:fair_users/model/user_response.dart';
import 'package:fair_users/service/fair_api.dart';
import 'package:fair_users/view/favorite_users.dart';
import 'package:fair_users/view/user_details.dart';
import 'package:flutter/material.dart';

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
  late Future<UserResponse> usersResponse;
  final _users = <User>[];
  final _saved = <User>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    usersResponse = fetchUsers();
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
        child: FutureBuilder<UserResponse>(
          future: usersResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              _users.clear();
              _users.addAll(snapshot.data!.data);
              if(_selectedIndex == 0) {
                return _buildUsers();
              } else {
                return _buildUsersGrid();
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

  Widget _buildUsers() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _users.length,
        itemBuilder: (context, i) {
          return _buildRow(_users[i]);
        });
  }

  Widget _buildUsersGrid() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: _users.length,
        itemBuilder: (context, i) {
          return _buildGridRow(_users[i]);
        });
  }

  Widget _buildRow(User user) {
    final alreadySaved = _saved.contains(user);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.picture),
          radius: 30,
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: _biggerFont,
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
              _saved.remove(user);
            } else {
              _saved.add(user);
            }
          });
        },
      ),
    );
  }

  Widget _buildGridRow(User user) {
    final alreadySaved = _saved.contains(user);
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
              _saved.remove(user);
            } else {
              _saved.add(user);
            }
          });
        },
      ),
    );
  }
}