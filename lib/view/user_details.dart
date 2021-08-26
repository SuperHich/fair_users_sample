import 'package:fair_users/model/location.dart';
import 'package:fair_users/model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails(this.user);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final double kMinRadius = 32.0;
  final double kMaxRadius = 128.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.firstName} details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: details(widget.user),
        ),
      )

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

  RectTween createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  Widget detailHeader(User user) {
    return
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Hero(
          createRectTween: createRectTween,
          tag: user.id,
          child: RadialExpansion(
            maxRadius: kMaxRadius,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.picture),
              radius: 60,
            ),
          ),
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

}

class RadialExpansion extends StatelessWidget {
  const RadialExpansion({
    Key? key,
    required this.maxRadius,
    this.child,
  })  : clipRectSize = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);

  final double maxRadius;
  final double clipRectSize;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}