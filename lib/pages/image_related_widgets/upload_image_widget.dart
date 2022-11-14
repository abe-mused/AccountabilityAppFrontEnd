import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear/pages/image_related_widgets/single_image_picker.dart';

enum PhotoStatus { LOADING, ERROR, LOADED, NONE }
enum PhotoSource { ASSET, NETWORK, NONE }

class UploadImageWidget extends StatefulWidget {
  UploadImageWidget(
      {super.key,
      required this.token,
      required this.onSuccess,
      required this.onCancel,
      required this.onLoading});
  
  String token;
  final Function onSuccess;
  final Function onCancel;
  final Function onLoading;
  
  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  PhotoSource photoSource = PhotoSource.NONE;
  PhotoStatus photoStatus = PhotoStatus.NONE;
  String source = "";
  XFile? localImage;

  @override
  Widget build(BuildContext context) {
    
    final SingleImagePicker picker = SingleImagePicker(
      token: widget.token,
      pickImageSource: PickImageSource.BOTH,
      onImagePicked: (image) => {
        setState(() {
          photoStatus = PhotoStatus.LOADED;
          photoSource = PhotoSource.ASSET;
          localImage = image;
        })
      },
      onImageRemoved: () => {
        setState(() {
          localImage = null;
          photoStatus = PhotoStatus.NONE;
          photoSource = PhotoSource.NONE;
        }),
      },
      onImageSuccessfullyUploaded: (downloadUrl) => {
        print("Image uploaded successfully${downloadUrl}"),
      },
      onImageUploadFailed: (message) => {
        print("Image upload failed: ${message}"),
        setState(() {
          photoStatus = PhotoStatus.ERROR;
        }),
      },
    );

    _buildAddPhotoButton() {
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

    _buildRemovePhotoButton() {
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

    _buildActionRow() {
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
                downloadURL = await picker.uploadImage(localImage!);
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
            Container(
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey.shade200,
                      child: photoSource == PhotoSource.NETWORK?
                                Image.network(source, height: 200)
                                : photoSource == PhotoSource.ASSET?
                                  Image.file(File(localImage!.path), height: 200)
                                  : Container(color: Colors.white, height: 200),
                    ),
                  ),
                  Align(
                    alignment: photoStatus == PhotoStatus.LOADED?
                      Alignment.topRight
                      : Alignment.center,
                    child: photoStatus == PhotoStatus.LOADING?
                            const CircularProgressIndicator()
                            : photoStatus == PhotoStatus.ERROR?
                              const Icon(Icons.error, color: Colors.red, size: 40)
                              : photoStatus == PhotoStatus.NONE?
                                _buildAddPhotoButton()
                                : photoStatus == PhotoStatus.LOADED?
                                  _buildRemovePhotoButton()
                                  : Container(),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildActionRow(),
            ),
          ],
        )
    );
  }
}