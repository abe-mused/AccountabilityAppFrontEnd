// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;
import 'package:linear/constants/themeSettings.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hide = true;

  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  // check for sign up through cognito
  doSignUp() {
    final Future<Map<String, dynamic>> responseMessage =
        authUtil.signUp(email: email.text, password: password.text, username: username.text, fullName: name.text);

    responseMessage.then((response) {
      if (response['status'] == true) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("You have successfully created an account!"),
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
                content: const Text("An error occured while creating your account. Please try again later."),
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
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? AppThemes.darkTheme.primaryColor
          : AppThemes.lightTheme.primaryColor,
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 40),
            child: Text("Create Your Account", style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.w300)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? ThemeData.dark().primaryColor : Colors.white,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))),
            child: SingleChildScrollView(
              // removes bottom overflow pixel error
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: "E-mail",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: username,
                    decoration: const InputDecoration(
                      hintText: "username",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: "Full name",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: password,
                    obscureText: hide,
                    decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: hide ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: confirmPassword,
                    obscureText: hide,
                    decoration: InputDecoration(
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: hide ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60)),
                        onPressed: () {
                          handleSignUpPress(context);
                        },
                        child: const Text("Sign Up")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text("Sign In?"))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleSignUpPress(BuildContext context) {
    RegExp usernameValidation = RegExp(r"^[A-Za-z][A-Za-z0-9_]{5,30}$");
    RegExp emailValidation = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    RegExp passwordValidation = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$');
    if (password.text.isEmpty || confirmPassword.text.isEmpty || email.text.isEmpty || username.text.isEmpty || name.text.isEmpty) {
      showErrorDialog(context, "Please fill out all fields!");
    } else if (!emailValidation.hasMatch(email.text)) {
      showErrorDialog(context, "Invalid email! please try again.");
    } else if (!usernameValidation.hasMatch(username.text)) {
      showErrorDialog(context,
          "Invalid username! Username has to be a minimum of 5 characters and must contain alphanumeric characters and optionally an underscore");
    } else if (!passwordValidation.hasMatch(password.text)) {
      showErrorDialog(context,
          "Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character");
    } else if (password.text != confirmPassword.text) {
      showErrorDialog(context, "Passwords do not match!");
    } else {
      doSignUp();
    }
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("ERROR"),
            content: Text(errorMessage),
          );
        });
  }
}
