import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

postComment() {
  return const Text("Comment");
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Comments"),
        ),
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
                            decoration: const BoxDecoration(
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
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(60),
                                    borderSide: const BorderSide(
                                        style: BorderStyle.none)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(60),
                                    borderSide: const BorderSide(
                                        style: BorderStyle.none)),
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
