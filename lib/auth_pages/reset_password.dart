import 'package:flutter/material.dart';
import 'package:linear/auth_pages/reset_password_code.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/util/cognito/auth_util.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool hide = true;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final email = TextEditingController();

  AuthUtility auth = AuthUtility();

  doSendResetCode() {
    final Future<Map<String, dynamic>> successfulMessage =
        auth.passwordResetCode(email: email.text);

    successfulMessage.then((response) {
      if (response['status'] == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ResetPasswordCodePage(email: email.text)));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while sending the password reset code. Please try again later."),
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
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, left: 50),
              child: Text(
                "Reset Your \nPassword",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w300),
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
                      topLeft: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Email",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
                  ),
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
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 60)),
                        onPressed: () {
                          RegExp emailValidation = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailValidation.hasMatch(email.text)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("ERROR"),
                                    content: const Text(
                                        "Invalid email! please try again."),
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
                            doSendResetCode();
                          }
                        },
                        child: const Text("Submit")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text("Login instead?"))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
