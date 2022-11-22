import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear/pages/image_related_widgets/add_image_modal.dart';
import 'package:linear/util/image_utils/single_image_util.dart';
import 'package:linear/util/image_utils/image_premissions_util.dart';

enum Source { GALLERY, CAMERA, NONE }
enum PickImageSource { GALLERY, CAMERA, BOTH }

class SingleImagePicker {
  final PickImageSource pickImageSource;
  final Function(XFile image) onImagePicked;
  final Function(String downloadUrl) onImageSuccessfullyUploaded;
  final Function() onImageRemoved;
  final Function(String message) onImageUploadFailed;

  SingleImagePicker({
    this.pickImageSource = PickImageSource.BOTH,
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

      if (pickImageSource == PickImageSource.BOTH) {
        Size size = MediaQuery.of(context).size;
        var sheet = AddAttachmentModalSheet(size);
        await showModalBottomSheet(
          context: context,
          builder: (context) => sheet,
          isScrollControlled: true,
        );

        if (sheet.source == Source.CAMERA) {
          imageSource = ImageSource.camera;
        } else if (sheet.source == Source.GALLERY) {
          imageSource = ImageSource.gallery;
        } else {
          return;
        }
      } else if (pickImageSource == PickImageSource.CAMERA) {
        imageSource = ImageSource.camera;

        GetImagePermission getPermission = GetImagePermission.camera();
        await getPermission.getPermission(context);

        if (getPermission.granted == false) {
          //Permission is not granted
          return;
        }
      } else if (pickImageSource == PickImageSource.GALLERY) {
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
        print("Image picked!");
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