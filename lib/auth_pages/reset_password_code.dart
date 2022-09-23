import 'package:flutter/material.dart';
import 'package:linear/auth_pages/reset_password_new_password.dart';

class ResetPasswordCodePage extends StatefulWidget {
  const ResetPasswordCodePage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordCodePage> createState() => _ResetPasswordCodePageState();
}

class _ResetPasswordCodePageState extends State<ResetPasswordCodePage> {
  bool hide = true;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, left: 40),
              child: Text(
                "Enter Verification \nCode Sent To \nYour Email",
                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45),
              width: double.infinity,
              height: 450,
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Code",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Password Reset Code",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent, padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60)),
                        onPressed: () {
                          //add some sort of validation for code
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordNewPasswordPage()));
                        },
                        child: const Text("Submit")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't Recieve a Code?"),
                      TextButton(
                          onPressed: () {
                            //add code send here
                          },
                          child: const Text("Resend"))
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
//thanks for watching