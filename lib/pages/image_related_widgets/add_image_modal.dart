// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:linear/util/image_utils/image_premissions_util.dart';

import './single_image_picker.dart';

class AddAttachmentModalSheet extends StatefulWidget {
  final Size screenSize;
  Source source = Source.NONE;

  AddAttachmentModalSheet(this.screenSize, {super.key});

  @override
  State<AddAttachmentModalSheet> createState() =>
      _AddAttachmentModalSheetState();
}

class _AddAttachmentModalSheetState extends State<AddAttachmentModalSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Upload", style: const TextStyle(fontSize: 26, color: Colors.black)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: Colors.grey),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildOption(Icons.camera, 'Camera',
                () => _onPickFromCameraClicked(context)),
            _buildOption(Icons.photo_library, 'Photo library',
                () => _onAddPhotoClicked(context)),
          ],
        ),
      ),
    );
  }

  _buildOption(IconData optionIcon, String optionName, void Function() onItemClicked) {
    return GestureDetector(
      onTap: onItemClicked,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(optionIcon),
            SizedBox(width: 8),
            Text(
              optionName,
              style: TextStyle(color: Colors.black, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  _onAddPhotoClicked(context) async {
    GetImagePermission getPermission = GetImagePermission.gallery();
    await getPermission.getPermission(context);

    if (getPermission.granted) {
      widget.source = Source.GALLERY;
      Navigator.pop(context);
    }
  }

  _onPickFromCameraClicked(context) async {
    GetImagePermission getPermission = GetImagePermission.camera();
    await getPermission.getPermission(context);

    if (getPermission.granted) {
      widget.source = Source.CAMERA;
      Navigator.pop(context);
    }
  }
}