import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;
import 'package:linear/constants/themeSettings.dart';

class ResetPasswordCodePage extends StatefulWidget {
  const ResetPasswordCodePage({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<ResetPasswordCodePage> createState() => _ResetPasswordCodePageState();
}

class _ResetPasswordCodePageState extends State<ResetPasswordCodePage> {
  bool hide = true;
  bool _updateResetPasswordCode = false;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController code = TextEditingController();

  doSendResetCode() {
    final Future<Map<String, dynamic>> successfulMessage = authUtil.passwordResetCode(email: widget.email);

    successfulMessage.then((response) {
      if (response['status']) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text(
                    "A password reset code has been sent succesfully. If you did not recieve a code check your spam folder or the email may not be registered."),
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
                content: const Text("An error occured while sending the password reset code. Please try again later."),
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

  doChangePassword() {
    final Future<Map<String, dynamic>> successfulMessage =
        authUtil.passwordReset(email: widget.email, code: code.text, password: password.text);

    successfulMessage.then((response) async {
      if (response['status'] == true) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Your password has been reset succesfully. Please login with your new password."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text(
                    "An error occured while attempting to change your password. Please request a new code or register an account."),
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, left: 50),
              child: Text(
                "Code Sent To Email",
                style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.w300),
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
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Code and New Password",
                      style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      key: const Key('codeKey'),
                      controller: code,
                      decoration: const InputDecoration(
                        hintText: "Password Reset Code",
                      ),
                    ),
                    TextField(
                      key: const Key('passwordKey'),
                      controller: password,
                      obscureText: hide,
                      decoration: InputDecoration(
                          hintText: "New Password",
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
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60)),
                          onPressed: () {
                            RegExp passwordValidation = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (password.text.isEmpty || confirmPassword.text.isEmpty || code.text.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error!"),
                                      content: const Text("Please fill out all fields!"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Ok"))
                                      ],
                                    );
                                  });
                            } else if (!passwordValidation.hasMatch(password.text)) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error!"),
                                      content: const Text(
                                          "Password must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Ok"))
                                      ],
                                    );
                                  });
                            } else if (password.text != confirmPassword.text) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error!"),
                                      content: const Text("Passwords do not match each other, please try again."),
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
                              _updateResetPasswordCode = true;
                              doChangePassword();
                            }
                            );
                            }
                          },
                         child: _updateResetPasswordCode? const CircularProgressIndicator(
                          color: Colors.white,
                        ) : const Text("Submit")
                        ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            key: const Key('resendCodeKey'),
                            onPressed: () {
                              doSendResetCode();
                            },
                            child: const Text("Resend")),
                        const Text("code or"),
                        TextButton(
                            key: const Key('registerButtonKey'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                            },
                            child: const Text("Login")),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
