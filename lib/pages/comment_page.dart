import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey))),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: (() {})),
                                contentPadding: const EdgeInsets.all(5),
                                // border: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         style: BorderStyle.none,
                                //         color: Colors.blue),
                                //     borderRadius: BorderRadius.circular(50)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(60),
                                    borderSide:
                                        BorderSide(style: BorderStyle.none)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(60),
                                    borderSide:
                                        BorderSide(style: BorderStyle.none)),
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            )),
                      ],
                    )
                  ]),
                ),
              ))
        ]),
      ),
    );
  }
}
