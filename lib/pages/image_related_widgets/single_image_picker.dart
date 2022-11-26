import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear/pages/image_related_widgets/add_image_modal.dart';
import 'package:linear/util/image_utils/single_image_util.dart';
import 'package:linear/util/image_utils/image_premissions_util.dart';
import 'dart:developer' as developer;


enum Source { gallery, camera, none }
enum PickImageSource { gallery, camera, both }

class SingleImagePicker {
  final PickImageSource pickImageSource;
  final Function(XFile image) onImagePicked;
  final Function(String downloadUrl) onImageSuccessfullyUploaded;
  final Function() onImageRemoved;
  final Function(String message) onImageUploadFailed;

  SingleImagePicker({
    this.pickImageSource = PickImageSource.both,
    required this.onImagePicked,
    required this.onImageRemoved,
    required this.onImageSuccessfullyUploaded,
    required this.onImageUploadFailed,
  });

  final ImagePicker imagePicker = ImagePicker();
  bool isImagePicked = false;
  XFile? image;

  Future<void> pickImage(context) async {
    try {
      ImageSource imageSource;

      if (pickImageSource == PickImageSource.both) {
        Size size = MediaQuery.of(context).size;
        var sheet = AddAttachmentModalSheet(size);
        await showModalBottomSheet(
          context: context,
          builder: (context) => sheet,
          isScrollControlled: true,
        );

        if (sheet.source == Source.camera) {
          imageSource = ImageSource.camera;
        } else if (sheet.source == Source.gallery) {
          imageSource = ImageSource.gallery;
        } else {
          return;
        }
      } else if (pickImageSource == PickImageSource.camera) {
        imageSource = ImageSource.camera;

        GetImagePermission getPermission = GetImagePermission.camera();
        await getPermission.getPermission(context);

        if (getPermission.granted == false) {
          //Permission is not granted
          return;
        }
      } else if (pickImageSource == PickImageSource.gallery) {
        imageSource = ImageSource.gallery;

        GetImagePermission getPermission = GetImagePermission.gallery();
        await getPermission.getPermission(context);

        if (getPermission.granted == false) {
          //Permission is not granted
          return;
        }
      } else {
        return;
      }

      image = await imagePicker.pickImage(source: imageSource);

      if (image != null) {
        onImagePicked.call(image!);
        isImagePicked = true;
        developer.log("Image picked!");
      }
    } catch (e) {
      onImageUploadFailed(e.toString());
    }
  }

  Future<String> uploadImage(XFile localImage, BuildContext context) async {
    try{
      SingleImageUtility singleImageUtility = SingleImageUtility();

      await singleImageUtility.generateUploadUrl(context);
      if (!singleImageUtility.isUploadUrlGenerated) {
        throw "Error generating upload url for your image!";
      }

      await singleImageUtility.uploadImage(localImage);
      if (!singleImageUtility.isImageUploaded) {
        throw "Error uploading your image!";
      }

      onImageSuccessfullyUploaded(singleImageUtility.downloadUrl);
      return singleImageUtility.downloadUrl;
    } catch (e) {
      onImageUploadFailed(e.toString());
      return "IMAGE_UPLOAD_FAILED";
    }
  }

  Future<void> removeImage() async {
    isImagePicked = false;
    image = null;
    onImageRemoved();
  }
}