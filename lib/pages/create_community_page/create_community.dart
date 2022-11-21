import 'package:flutter/material.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/pages/community_page/community_page.dart';

class CreateCommunityWidget extends StatefulWidget {
  const CreateCommunityWidget({super.key});

  @override
  State<CreateCommunityWidget> createState() => _CreateCommunityWidgetState();
}

class _CreateCommunityWidgetState extends State<CreateCommunityWidget> {
  TextEditingController userInput = TextEditingController();
  bool _isLoading = false;

  doCreateCommunity() {
    final Future<Map<String, dynamic>> successfulMessage = createCommunity(context, userInput.text);

    successfulMessage.then((response) {
      setState(() {
         _isLoading = false;
      });
      
      if (response['status'] == true) {
        joinAndLeave(context, userInput.text);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Community succesfully Created."),
                actions: [
                  TextButton(
                      onPressed: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityPage(
                          communityName: userInput.text,
                        ),
                      ),
                    );
                   
                  },
                      child: const Text("Ok"))
                ],
              );
            });
      } else if (response['message'] == 'The community already exists!'){
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(""),
                content: const Text("Community already exists!"),
                actions:  <Widget>[
                  TextButton(
                     onPressed: () => Navigator.pop(context, 'Cancel'),
                     child: const Text('Cancel'),
                    ),
                  TextButton(
                      onPressed: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityPage(
                          communityName: userInput.text,
                        ),
                      ),
                    );
                    
                  },
                      child: const Text("Go to Community"))
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text("An error occured while attempting to create the community."),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(10),
        child: TextFormField(
          controller: userInput,
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
            hintText: "Enter the name of your community",
          ),
        ),
      ),
        if (!_isLoading)
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await doCreateCommunity();
            },
             child:  const Text("Submit"),
        ),
        if (_isLoading)
          ElevatedButton(
             onPressed: () {},
              child: const SizedBox(
              height: 10.0,
              width: 10.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
             ),
          ),
    ]);
  }
}
