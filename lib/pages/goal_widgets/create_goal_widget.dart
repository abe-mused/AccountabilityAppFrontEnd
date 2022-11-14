import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/model/goal.dart';

class CreateGoalWidget extends StatefulWidget {
  CreateGoalWidget({super.key, required this.token, required this.communityName, required this.onSuccess});
  String token;
  String communityName;
  final Function onSuccess;

  @override
  State<CreateGoalWidget> createState() => _CreateGoalWidgetState();
}

class _CreateGoalWidgetState extends State<CreateGoalWidget> {
  TextEditingController goalBodyInput = TextEditingController();
  TextEditingController checkInGoalInput = TextEditingController();

  bool _isCreatingGoal = false;
  Goal _goal = Goal(
    communityName: '',
    goalId: '',
    creator: '',
    creationDate: 0,
    checkInGoal: 0,
    goalBody: '',
    completedCheckIns: 0
  );
  

  doCreatePost() {
    setState(() {
      _isCreatingGoal = true;
    });

    final Future<Map<String, dynamic>> successfulMessage = createGoal(
        int.parse(checkInGoalInput.text.toString()),
        goalBodyInput.text,
        widget.communityName,
        widget.token);

    successfulMessage.then((response) {
      if (response['status'] == true) {
         Goal goal = Goal(
            communityName: widget.communityName,
            goalId:  ' '/*response['goalId']*/,
            creator: ' ',
            creationDate: 0 /*int.parse(response['creationDate'])*/,
            checkInGoal: int.parse(checkInGoalInput.text.toString()),
            goalBody: goalBodyInput.text,
            completedCheckIns: 0
            );

        setState(() {
          _goal = goal;
        });

        widget.onSuccess(_goal);

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
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Card(
        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Make a goal for yourself in c/${widget.communityName}!",
                style: const TextStyle(fontSize: 24),
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
                    hintText: "Goal",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: checkInGoalInput,
                  keyboardType: TextInputType.number,
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
                    hintText: "Days",
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
                      if (goalBodyInput.text != '' &&
                          checkInGoalInput.text != '') {
                        doCreatePost();
                      } else {
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
                            });
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