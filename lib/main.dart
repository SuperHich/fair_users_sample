import 'dart:async';

import 'package:fair_users/model/location.dart';
import 'package:fair_users/model/user.dart';
import 'package:fair_users/model/user_response.dart';
import 'package:fair_users/service/fair_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    usersResponse = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fair users'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: Center(
        child: FutureBuilder<UserResponse>(
          future: usersResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return _buildUsers(snapshot.data!.data);
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

  Widget _buildUsers(List<User> users) {
    _users.addAll(users);
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (context, i) {
          return _buildRow(_users[i]);
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
          _pushDetails(user);
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

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (User user) {
              return ListTile(
                title: Text(
                  '${user.firstName} ${user.lastName}',
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushDetails(User user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          Future<User> userDetails = fetchUserDetails(user.id);

          return Scaffold(
              appBar: AppBar(
                title: Text('${user.firstName} details'),
              ),
              body: Center(
                child: FutureBuilder<User>(
                  future: userDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return details(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              )
          );
        },
      ),
    );
  }

  Column details(User user) {
    return Column(
      children: [
        detailHeader(user),
        detailItem('${user.title} ${user.firstName} ${user.lastName}', Icons.person),
        const Divider(),
        detailItem('${new DateFormat('dd MMM yyyy').format(user.dateOfBirth!)}', Icons.card_giftcard),
        const Divider(),
        detailItem('${user.email}', Icons.mail),
        const Divider(),
        detailItem('${user.phone}', Icons.phone),
        const Divider(),
        detailItem('${buildAddress(user.location)}', Icons.map),
      ],
    );
  }

  Widget detailHeader(User user) {
    return
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(user.picture),
          radius: 60,
        ),
      );
  }

  Widget detailItem(String text, IconData icon) {
    return
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(
            text,
            style: _biggerFont,
          ),
          leading: Icon(
            icon,
            color: Colors.blue[500],
          ),
        ),
      );
  }

  String buildAddress(Location? location) {
    if(location != null) {
      return '${location.street} ${location.city} ${location.state} ${location.country}';
    }
    return "Not available";
  }
}