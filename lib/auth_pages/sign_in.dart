// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:linear/main.dart';
import '../util/auth_util.dart' as auth_util;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 40),
            child: Text("Create Your Account", style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w300)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))),
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
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60)),
                      onPressed: () {
                        if (password.text != confirmPassword.text) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("ERROR"),
                                  content: Text("Passwords do not match!"),
                                );
                              });
                        } else {
                          auth_util.signUp(
                            email: email.text,
                            password: password.text,
                            fullName: name.text,
                            username: username.text,
                          );
                        }
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
          )
        ],
      ),
    );
  }
}
