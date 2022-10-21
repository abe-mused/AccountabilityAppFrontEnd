import 'package:flutter/material.dart';

class CommunityInfoBox extends StatelessWidget {
  //const CommunityInfoBox({Key? key}) : super(key: key);
  CommunityInfoBox({
    super.key,
    required this.communityName,
    required this.dateCreated,
    required this.creator,
  });

  String communityName;
  String dateCreated;
  String creator;

  @override 
  Widget build(BuildContext context) {
    return 
         Column(children: <Widget>[
          Expanded( 
            flex: 3,
            child: Column( 
              children: <Widget>[
                const Expanded(flex: 1, child: Icon(Icons.search)),
                  Expanded(
                   flex: 3,
                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("c/" + communityName),
                        Text("Created: " + dateCreated),
                        Text("Created by u/" + creator)
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