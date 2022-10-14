import 'package:flutter/material.dart';

class ScrollingPostView extends StatelessWidget {
  ScrollingPostView({
    super.key,
    required this.username,
    required this.titleOfPost,
    required this.postText,
    required this.communityName,
    required this.dateCreated,
    });

    String username = "CommunityName";
    String titleOfPost = "Post Title";
    String postText = "Post Body";
    String communityName = "communityName";
    String dateCreated = "dateCreated";

  @override 
  Widget build(BuildContext context) {
    return AspectRatio( 
      aspectRatio: 3/2,
      child: Card( 
        child: Column(children: <Widget>[
          Expanded( 
            flex: 3,
            child: Row( 
              children: <Widget>[
                Expanded(flex: 1, child: Icon(Icons.person)),
                  Expanded(
                   flex: 3,
                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(titleOfPost),
                        Text(postText),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded( 
                flex: 1,
                /******
                child: CircleAvatar( 
                  backgroundImage: AssetImage(dummy_data.profilePicture),
                ),
                ****/
                child: 
                  Icon(Icons.home),
              ),
              Expanded(
                flex: 7,
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(username),
                    Text(communityName),
                  ],
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
