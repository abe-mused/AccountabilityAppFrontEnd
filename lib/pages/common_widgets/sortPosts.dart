import 'package:flutter/material.dart';

class SortPosts extends StatefulWidget {
  SortPosts(
      {Key? key,
      required this.posts,
      required this.onSort,
      this.isCommunityPage = false})
      : super(key: key);

  List posts;
  final Function onSort;
  bool isCommunityPage;

  @override
  State<SortPosts> createState() => SortPostsState();
}

class SortPostsState extends State<SortPosts> {
  latestDate() {
    widget.posts.sort((a, b) => b['creationDate'].compareTo(a['creationDate']));
    sortType = 'Newest';
    widget.onSort(widget.posts);
  }

  oldestDate() {
    widget.posts.sort((a, b) => a['creationDate'].compareTo(b['creationDate']));
    sortType = 'Oldest';
    widget.onSort(widget.posts);
  }

  topLikes() {
    widget.posts.sort((a, b) => b['likes'].length.compareTo(a['likes'].length));
    sortType = 'Top Liked';
    widget.onSort(widget.posts);
  }

  topComments() {
    widget.posts.sort((a, b) => b['commentCount'].compareTo(a['commentCount']));
    sortType = 'Most Comments';
    widget.onSort(widget.posts);
  }

  topInteractions() {
    widget.posts.sort((a, b) => (b['commentCount'] + b['likes'].length)
        .compareTo(a['commentCount'] + a['likes'].length));
    sortType = 'Most Interactions';
    widget.onSort(widget.posts);
  }

  communityAZ() {
    widget.posts.sort((a, b) => a['community'].compareTo(b['community']));
    sortType = 'Community A-Z';
    widget.onSort(widget.posts);
  }

  communityZA() {
    widget.posts.sort((a, b) => b['community'].compareTo(a['community']));
    sortType = 'Community Z-A';
    widget.onSort(widget.posts);
  }

  String sortType = 'Newest';
  num sortIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text(
        "Posts",
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 23.0,
          fontWeight: FontWeight.w900,
        ),
      ),
      Row(
        children: [
          Text(
            "Sorting By $sortType",
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          ),
          if (widget.posts.isNotEmpty)
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Newest"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Oldest"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Top Liked"),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Most Comments"),
                  ),
                  const PopupMenuItem<int>(
                    value: 4,
                    child: Text("Most Interactions"),
                  ),
                  if (!widget.isCommunityPage) ...[
                    const PopupMenuItem<int>(
                      value: 5,
                      child: Text("Communities A to Z"),
                    ),
                    const PopupMenuItem<int>(
                      value: 6,
                      child: Text("Communities Z to A"),
                    ),
                  ]
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  latestDate();
                } else if (value == 1) {
                  oldestDate();
                } else if (value == 2) {
                  topLikes();
                } else if (value == 3) {
                  topComments();
                } else if (value == 4) {
                  topInteractions();
                } else if (value == 5) {
                  communityAZ();
                } else if (value == 6) {
                  communityZA();
                }
              },
            )
        ],
      ),
    ]);
  }
}
