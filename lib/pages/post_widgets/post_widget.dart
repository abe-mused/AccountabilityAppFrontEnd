import 'package:flutter/material.dart';
import 'package:linear/model/post.dart';
import 'package:linear/util/date_formatter.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                "c/${post.communityName}",
                style: const TextStyle(fontFamily: 'MonteSerrat', fontSize: 16),
                textAlign: TextAlign.left,
              ),
              Text(
                "u/${post.creator}",
                style: const TextStyle(
                    fontFamily: 'MonteSerrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                "Created on ${getFormattedDate(post.creationDate)}",
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const Divider(
                height: 10,
                thickness: 0.6,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              Text(
                post.title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                post.body,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
