// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linear/util/apis.dart';

class CreateGoalWidget extends StatefulWidget {
  CreateGoalWidget({super.key, required this.communityName, required this.onSuccess});
  String communityName;
  final Function onSuccess;

  @override
  State<CreateGoalWidget> createState() => _CreateGoalWidgetState();
}

class _CreateGoalWidgetState extends State<CreateGoalWidget> {
  TextEditingController goalBodyInput = TextEditingController();
  TextEditingController checkInGoalInput = TextEditingController();

  RegExp goalBodyRegexValidation = RegExp(r"\w{5}\w{0,95}");

  bool _isCreatingGoal = false;

  doCreateGoal() {
    setState(() {
      _isCreatingGoal = true;
    });

    final Future<Map<String, dynamic>> responseMessage = createGoal(
        context,
        int.parse(checkInGoalInput.text.toString()),
        goalBodyInput.text.trim().replaceAll(RegExp(r' \s+'), ' '),
        widget.communityName,
        );

    responseMessage.then((response) {
      if (response['status'] == true) {
        widget.onSuccess(response['newGoal']);

        goalBodyInput.clear();
        checkInGoalInput.clear();
       showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Goal succesfully Created."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to create the goal."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      }
      setState(() {
        _isCreatingGoal = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCreatingGoal) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20.0),
                child: Text(
                  "Create a goal for yourself             in c/${widget.communityName}!", //the spaces here are to show the c/ in the next line
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: goalBodyInput,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Goal description...",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: checkInGoalInput,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter(allow: true, RegExp(r'[0-9]'))],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Target number of days...",
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (goalBodyInput.text == '' ||
                          checkInGoalInput.text == '') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  const Text("Please fill out all fields."),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ],
                            );
                          }
                        );
                      } else if(!goalBodyRegexValidation.hasMatch(goalBodyInput.text.trim().replaceAll(RegExp(r'\s+'), ''))) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  const Text("Goal description must be alphanumeric and between the length of 5-100 characters.\n\nThink of something meaningful!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ],
                            );
                          }
                        );
                      } else if(int.parse(checkInGoalInput.text) >= 1000 || int.parse(checkInGoalInput.text) < 1) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  const Text("Target number of days must be between 1-999"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ],
                            );
                          }
                        );
                      } else {
                        doCreateGoal();
                      }
                    },
                    child: const Text("create goal"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}