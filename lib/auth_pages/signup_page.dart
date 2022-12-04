import 'package:flutter/material.dart';
import 'package:linear/auth_pages/login_page.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;
import 'package:linear/constants/themeSettings.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hide = true;
  bool _isUpdatingSignUp = false;

  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  doSignUp() {
    final Future<Map<String, dynamic>> responseMessage =
        auth_util.signUp(email: email.text, password: password.text, username: username.text, fullName: name.text);

    responseMessage.then((response) {
      if (response['status'] == true) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: Text(response['message']),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
                      },
                      child: const Text("Login"))
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: Text(response['message']),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"),
                      )
                ],
              );
            });
      }
      setState(() {
        _isUpdatingSignUp = false;
    });
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    key: const Key('emailKey'),
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    key: const Key('usernameKey'),
                    controller: username,
                    decoration: const InputDecoration(
                      hintText: "Username",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    key: const Key('fullNameKey'),
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: "Full Name",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    key: const Key('passwordKey'),
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
                    key: const Key('confirmPasswordKey'),
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
                        ),
                        ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60)
                          ),
                          onPressed: () async {
                            setState(() {
                              _isUpdatingSignUp = true;
                            });
                          handleSignUpPress(context);
                        },
                         child: _isUpdatingSignUp? const CircularProgressIndicator(
                          color: Colors.white,
                        ) : const Text("Sign up")
                        ),
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
                          child: const Text("Login"),
                      )
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
            title: const Text("Error!"),
            content: Text(errorMessage),
          );
        });
  }
}
