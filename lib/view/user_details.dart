import 'package:fair_users/model/location.dart';
import 'package:fair_users/model/user.dart';
import 'package:fair_users/service/fair_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails(this.user);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    Future<User> userDetails = fetchUserDetails(widget.user.id);

    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.user.firstName} details'),
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
  }
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
          style: const TextStyle(fontSize: 18.0),
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