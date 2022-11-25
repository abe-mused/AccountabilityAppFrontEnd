import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:linear/auth_pages/reset_password.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;
import 'package:linear/constants/themeSettings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool _isUpdatingSignIn = false;

  final emailOrUsername = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    doLogIn() {
      final Future<Map<String, dynamic>> responseMessage = auth_util.login(emailOrUsername.text, password.text);

      responseMessage.then((response) {
        if (response['status'] == true) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Failed Login"),
                  content: Text(response['message']),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok"),
                    ),
                  ],
                );
              });
        }
        setState(() {
          _isUpdatingSignIn = false;
        });
      });
    }

    return Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? AppThemes.darkTheme.primaryColor
          : AppThemes.lightTheme.primaryColor,
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, left: 50),
            child: Text(
              "Welcome to linear!",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.35,
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: BoxDecoration(
              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? ThemeData.dark().primaryColor : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: emailOrUsername,
                    decoration: const InputDecoration(
                      hintText: "Email or username",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    obscureText: hidePassword,
                    controller: password,
                    decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: hidePassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordPage()));
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                        ),
                        onPressed: () async {
                            setState(() {
                              _isUpdatingSignIn = true;
                            });
                          doLogIn();
                        },
                        child: _isUpdatingSignIn? const CircularProgressIndicator(
                          color: Colors.white,
                        ) : const Text("Login")
                        ),
                  ),  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text("Sign Up"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
