// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:linear/inroduction_page/intro_banner.dart';

class LinearErrorScreen extends StatelessWidget {
  LinearErrorScreen({
    super.key,
    required this.errorMessage,
  });

  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        const LinearIntroBanner(),
        Container(
          margin: const EdgeInsets.fromLTRB(50, 50, 50, 10),
          child: Image.asset('assets/unknown_error.png'),
        ),
        const Text(
          "Opps! Something went wrong",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ]
    );
  }
}