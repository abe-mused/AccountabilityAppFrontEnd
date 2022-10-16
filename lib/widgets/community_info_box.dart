import 'package:flutter/material.dart';

class CommunityInfoBox extends StatelessWidget {
  //const CommunityInfoBox({Key? key}) : super(key: key);
  CommunityInfoBox({
    super.key,
    required this.communityName,
    required this.dateCreated,
  });

  String communityName = "CommunityName";
  String dateCreated = "10/01/22";

  @override 
  Widget build(BuildContext context) {
    return 
         Column(children: <Widget>[
          Expanded( 
            flex: 3,
            child: Column( 
              children: <Widget>[
                const Expanded(flex: 1, child: Icon(Icons.book)),
                  Expanded(
                   flex: 3,
                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(communityName),
                        Text("Founded: " + dateCreated),
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