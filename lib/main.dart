import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:linear/auth_pages/reset_password.dart';
import 'package:linear/pages/home_page.dart';
import 'util/auth_util.dart' as auth_util;

main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  ); // MaterialApp
}

//TO DO: take this out into its own file and import it
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 78, 59),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, left: 50),
            child: Text(
              "Welcome to linear!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
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
                    hintText: "E-mail or Username",
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
                        icon: hidePassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage()));
                    },
                    child: const Text("Forgot password?"),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 60),
                      ),
                      onPressed: () {
                        auth_util.logIn(
                            username: emailOrUsername.text,
                            password: password.text);
                        //TODO: this should not be a push, it should be a replace
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
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
                                  builder: (context) => const SignUpPage()));
                        },
                        child: const Text("Sign Up"))
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
