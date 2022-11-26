import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear/pages/image_related_widgets/single_image_picker.dart';
import 'dart:developer' as developer;

enum PhotoStatus { loading, error, loaded, none }
enum PhotoSource { asset, network, none }

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget(
      {super.key,
      required this.onSuccess,
      required this.onCancel,
      required this.onLoading});
  
  final Function onSuccess;
  final Function onCancel;
  final Function onLoading;
  
  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  PhotoSource photoSource = PhotoSource.none;
  PhotoStatus photoStatus = PhotoStatus.none;
  String source = "";
  XFile? localImage;

  @override
  Widget build(BuildContext context) {
    
    final SingleImagePicker picker = SingleImagePicker(
      pickImageSource: PickImageSource.both,
      onImagePicked: (image) => {
        setState(() {
          photoStatus = PhotoStatus.loaded;
          photoSource = PhotoSource.asset;
          localImage = image;
        })
      },
      onImageRemoved: () => {
        setState(() {
          localImage = null;
          photoStatus = PhotoStatus.none;
          photoSource = PhotoSource.none;
        }),
      },
      onImageSuccessfullyUploaded: (downloadUrl) => {
        developer.log("Image uploaded successfully$downloadUrl"),
      },
      onImageUploadFailed: (message) => {
        developer.log("Image upload failed: $message"),
        setState(() {
          photoStatus = PhotoStatus.error;
        }),
      },
    );

    buildAddPhotoButton() {
      return TextButton(
          onPressed: () async {
            await picker.pickImage(context);            
          },
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_a_photo),
                Text("Add Photo"),
              ],
            ),
      );
    }

    buildRemovePhotoButton() {
      return TextButton(
          onPressed: () async {
            await picker.removeImage(); 
            localImage = null;          
          },
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.close),
              ],
            ),
      );
    }

    buildActionRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              widget.onCancel();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              String? downloadURL;
              if(localImage != null && widget.onLoading()){
                downloadURL = await picker.uploadImage(localImage!, context);
              }
              widget.onSuccess(downloadURL);
            },
            child: const Text("Submit"),
          )
        ]
      );
    }

    return Center(
      child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey.shade200,
                      child: photoSource == PhotoSource.network?
                                Image.network(source, height: 200)
                                : photoSource == PhotoSource.asset?
                                  Image.file(File(localImage!.path), height: 200)
                                  : Container(color: Colors.white, height: 200),
                    ),
                  ),
                  Align(
                    alignment: photoStatus == PhotoStatus.loaded?
                      Alignment.topRight
                      : Alignment.center,
                    child: photoStatus == PhotoStatus.loading?
                            const CircularProgressIndicator()
                            : photoStatus == PhotoStatus.error?
                              const Icon(Icons.error, color: Colors.red, size: 40)
                              : photoStatus == PhotoStatus.none?
                                buildAddPhotoButton()
                                : photoStatus == PhotoStatus.loaded?
                                  buildRemovePhotoButton()
                                  : Container(),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildActionRow(),
            ),
          ],
        )
    );
  }
}