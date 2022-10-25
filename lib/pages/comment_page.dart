import 'package:flutter/material.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';

class CommentPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentPage({
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  });

  @override
  CommentPageState createState() => CommentPageState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}

class CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentPageState({
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  });

  buildComments() {
    return Text("Comment");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlinedButton(
              onPressed: () => print('Add comment'),
              child: Text('Post'),
            ),
          ),
        ],
      ),
    );
  }

  header(BuildContext context, {required String titleText}) {}
}

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Comment');
  }
}
