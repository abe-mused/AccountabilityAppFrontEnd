import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/util/apis.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({Key? key}) : super(key: key);

  @override
  State<CreateCommunityPage> createState() => CreateCommunityPageState();
}

class CreateCommunityPageState extends State<CreateCommunityPage> {

  TextEditingController userInput = TextEditingController();
  RegExp communityNameRegexValidation = RegExp(r"^(\w{3,30})$");

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
                      Navigator.pop(context);
                    },
                    child: const Text("Close")
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityPage(
                            communityName: userInput.text.toLowerCase(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Go to Community")
                  )
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
                          communityName: userInput.text.toLowerCase(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Community"),
        elevation: 0.1,
      ),
      body: Column(
      children: [
      Container(
        margin: const EdgeInsets.all(10),
        child: TextFormField(
          controller: userInput,
          maxLength: 30,
          style: const TextStyle(
            fontSize: 20,
          ),
          inputFormatters: [
          LengthLimitingTextInputFormatter(50),
          ],
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
              if(!communityNameRegexValidation.hasMatch(userInput.text)){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Invalid input!"),
                          content: const Text(
                              "community name must be between 3-30 alphanumeric characters long."),
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
                setState(() {
                  _isLoading = true;
                });
                await doCreateCommunity();
              }
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
    ],
    ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}