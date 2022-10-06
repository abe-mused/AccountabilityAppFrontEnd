import 'package:flutter/material.dart';
import 'package:linear/nonwidget_files/dummy_data.dart';

class Post extends StatelessWidget {
  const Post({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final String title_of_post = dummy_data.title_of_post;
    final String post_text = dummy_data.post_text;
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
                        Text(title_of_post),
                        Text(post_text),
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
                    Text(dummy_data.username),
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


