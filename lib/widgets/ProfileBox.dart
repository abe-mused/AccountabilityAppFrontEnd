import 'package:flutter/material.dart';
import 'package:linear/nonwidget_files/dummy_data.dart';

class ProfileBox extends StatelessWidget {
  const ProfileBox({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final String username = dummy_data.username;
    final String community1 = dummy_data.test_community_1;
    final String community2 = dummy_data.test_community_2;
    final String dateJoined = dummy_data.dayPosted;
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
                        Text(dateJoined),
                        Text("Communities:"),
                        Text(community1),
                        Text(community2),
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