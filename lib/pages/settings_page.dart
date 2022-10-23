import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/logout_widget.dart';

class SettingsPage extends StatelessWidget {
  static final String patch = "lib/src/pages/settings_page.dart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(10.0),
              child: ListTile(
                onTap: () {
                  // open edit profile
                },
                title: const Text(
                  "Linear Profile",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.black,
                ),
                trailing: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text("Change Password"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      // open change password
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: const Icon(Icons.language_sharp),
                    title: const Text("Change Language"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      // open change language
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text("Change Location"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      // open change language
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout Account"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () async {
                      // open logout account
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogoutButton()));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Notification Settings",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.all(0),
              value: false,
              title: const Text("Receive notifications"),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
