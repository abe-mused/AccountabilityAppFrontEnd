import 'package:flutter/material.dart';

class ProfileInfoBox extends StatelessWidget {
  const ProfileInfoBox({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final String username = "username";
    final String community1 = "Community1";
    final String community2 = "Community2";
    final String dateJoined = "10/01/22";
    int totalCommunities = 2;
    return 
         Column(children: <Widget>[
          Expanded( 
            flex: 3,
            child: Column( 
              children: <Widget>[
                Expanded(flex: 1, child: Icon(Icons.person)),
                  Expanded(
                   flex: 3,
                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(username),
                        Text("Joined: " + dateJoined),
                        Text("Communities:"),
                        
                        TextButton(
                          onPressed: () { 
                             Navigator.pushNamed(context, '/community'); 
                          },
                            child: Text(community1),                      
                        ),
                         TextButton(
                          onPressed: () { 
                             Navigator.pushNamed(context, '/community'); 
                          },
                            child: Text(community2),                      
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
         ],
        );
    }
}