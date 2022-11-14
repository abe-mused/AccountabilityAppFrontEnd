import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class GetImagePermission {
  bool granted = false;

  Permission? _permission;
  String _subHeading = '';

  GetImagePermission.gallery() {
    _subHeading = "Photos permission is needed to select photos";

    _permission = Permission.storage;
  }

  GetImagePermission.camera() {
    _subHeading = "Camera permission is needed to take photos";
    _permission = Permission.camera;
  }

  Future<void> getPermission(context) async {
    if(_permission == null) {
      return;
    }
    PermissionStatus permissionStatus = await _permission!.status;

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context, _subHeading);

      permissionStatus = await _permission!.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context, _subHeading);
      } else {
        permissionStatus = await _permission!.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      granted = true;
      return;
    }
  }

  _showOpenAppSettingsDialog(context, String subHeading) {
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => AlertDialog(
          title: const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Permissions needed", style: TextStyle(fontSize: 18)),
            ),
          content: Text(
              subHeading,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          actions: const [
            TextButton(
              onPressed: openAppSettings,
              child: Text(
                "Open settings",
                textAlign: TextAlign.center,
              ),
            ),
          ]
        ),
      );
  }
}