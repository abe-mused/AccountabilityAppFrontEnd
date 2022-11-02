import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:linear/auth_pages/reset_password.dart';
import 'package:linear/util/cognito/auth_util.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import '../util/cognito/user.dart';
import 'package:linear/constants/themeSettings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;

  final emailOrUsername = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthUtility auth = AuthUtility();

    doLogIn() {
      final Future<Map<String, dynamic>> successfulMessage = auth.login(emailOrUsername.text, password.text);

      successfulMessage.then((response) {
        if (response['status']) {
          User user = response['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacementNamed(context, '/home');
        }
        // else {
        //   Flushbar(
        //     title: "Failed Login",
        //     message: response['message']['message'].toString(),
        //     duration: Duration(seconds: 3),
        //   ).show(context);
        // }
      });
    }
    
    return Scaffold(
      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? AppThemes.darkTheme.primaryColor : AppThemes.lightTheme.primaryColor,
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
            decoration:  BoxDecoration(
              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? ThemeData.dark().primaryColor : Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
            child: SingleChildScrollView(
              // removes bottom overflow pixel error
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: emailOrUsername,
                    decoration: const InputDecoration(
                      hintText: "E-mail or username",
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
                        onPressed: doLogIn,
                        child: const Text("Sign In")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Dont't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text("Sign Up"),
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
}
