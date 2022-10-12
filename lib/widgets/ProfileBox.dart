import 'package:flutter/material.dart';
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/widgets/listTextButtons.dart';

class ProfileBox extends StatelessWidget {
  const ProfileBox({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final String username = dummy_data.username;
    final String community1 = dummy_data.test_community_1;
    final String community2 = dummy_data.test_community_2;
    final String dateJoined = dummy_data.dayPosted;
    int totalCommunities = dummy_data.total_communities;
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
                        //Need to implement a loop here somehow to add all the
                        //communities a user is a part of.
                        //later, totalCommunities will instead be
                        //involving the communities attribute in the users table,
                        //where we will grab community names from that column and add them
                        //to the profile page with links to the
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