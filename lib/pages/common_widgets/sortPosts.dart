import 'package:flutter/material.dart';

class SortPosts extends StatelessWidget {
  SortPosts({Key? key, required this.posts, required this.onSort})
      : super(key: key);

  List posts;
  final Function onSort;

 
  topLikes() {
    posts.sort((a, b) => b['likes'].length.compareTo(a['likes'].length));
    onSort(posts);
  }

  topComments() {
    posts.sort((a, b) => b['commentCount'].compareTo(a['commentCount']));
    onSort(posts);
  }

  topInteractions() {
    posts.sort((a, b) => (b['commentCount'] + b['likes'].length).compareTo(a['commentCount'] + a['likes'].length));
    onSort(posts);
  }

  latestDate() {
    posts.sort((a, b) => b['creationDate'].compareTo(a['creationDate']));
    onSort(posts);
  }

  

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [ 
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text("Newest"),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text("Top Liked"),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: Text("Most Comments"),
            ),
            const PopupMenuItem<int>(
              value: 3,
              child: Text("Most Interactions"),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            latestDate();
          } else if (value == 1) {
            topLikes();
          } else if (value == 2) {
            topComments();
          } else if (value == 3) {
            topInteractions();
          }
        },
      )
    ]);
  }
}
