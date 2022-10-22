import 'package:flutter/material.dart';

class UserIcon extends StatefulWidget {
  const UserIcon({Key? key, required this.radius, required this.username})
      : super(key: key);

  final double radius;
  final String username;

  @override
  State<UserIcon> createState() => _UserIconState();
}

class _UserIconState extends State<UserIcon> {
  List colors = [
    Colors.blue,
    Colors.green,
    const Color.fromARGB(255, 141, 39, 32),
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.yellow,
    Colors.orange,
    Colors.grey,
    Colors.indigo
  ];

  doSetColor(username) {
    num sum = 0;
    for (int i = 0; i < username.length; i++) {
      sum += username.codeUnitAt(i)!;
    }    
    return colors[sum.toInt() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: doSetColor(widget.username),
      radius: widget.radius,
      child: Text(
        widget.username[0],
          style:  TextStyle(
          color: Colors.white, fontSize: (widget.radius)*0.9, fontWeight: FontWeight.bold)
        ),
    );
  }
}
