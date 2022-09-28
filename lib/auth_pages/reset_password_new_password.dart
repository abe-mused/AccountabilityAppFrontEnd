import 'package:flutter/material.dart';
import '../login.dart';

class ResetPasswordNewPasswordPage extends StatefulWidget {
  const ResetPasswordNewPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordNewPasswordPage> createState() => _ResetPasswordNewPasswordPageState();
}

class _ResetPasswordNewPasswordPageState extends State<ResetPasswordNewPasswordPage> {
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
                "Enter New \nPassword",
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
                    "New Password",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
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
                            backgroundColor: Colors.deepOrangeAccent, padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60)),
                        onPressed: () {
                          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          if(password.text.isEmpty || confirmPassword.text.isEmpty){
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("ERROR"),
                                    content: Text("Please fill out all fields!"),
                                  );
                                });
                          }
                          else if (!regex.hasMatch(password.text)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("ERROR"),
                                    content: Text("Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
                                  );
                                });
                          }
                          else if (password.text != confirmPassword.text) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("ERROR"),
                                    content: Text("Passwords do not match!"),
                                  );
                                }); 
                          }
                          else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Success!"),
                                    content: const Text("Your Password Has been Reset"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                          },
                                          child: const Text("Login"))
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text("Submit")),
                  ),
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