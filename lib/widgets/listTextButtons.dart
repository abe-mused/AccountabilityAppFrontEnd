import 'package:flutter/material.dart';
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/widgets/listTextButtons.dart';

class TextButtonList extends StatelessWidget {
  const TextButtonList({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final String community = dummy_data.test_community_1;
    return 
      TextButton(
        onPressed: () { 
          Navigator.pushNamed(context, '/fourth'); 
        },
        child: Text(community),                      
      );
    }
}