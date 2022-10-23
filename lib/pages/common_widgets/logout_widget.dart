import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linear/pages/profile_page.dart';

enum DialogsAction { yes, cancel }

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog();
        });
  }

  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: const Text(
                'Confirm',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }

// displays logout button
  @override
  Widget build(BuildContext context) {
    bool tappedYes = false;
    return RawMaterialButton(
      fillColor: Color.fromARGB(255, 39, 78, 59), // background color
      splashColor: Colors.white, // when user clicks
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: () async {
        // this should show a dialog with options for user
        createAlertDialog(context);
        final action = await yesCancelDialog(
            // context below displays message once user clicks logout button
            context,
            'Logout',
            'Are you sure you want to log out?');
        if (action == DialogsAction.yes) {
          setState(() => tappedYes = true);
        } else {
          setState(() => tappedYes = false);
        }
      },
      child: Text(
        'Logout'.toUpperCase(),
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
