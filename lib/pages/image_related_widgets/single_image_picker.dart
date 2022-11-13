import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linear/pages/image_related_widgets/add_image_modal.dart';
import 'package:linear/util/image_utils/single_image_util.dart';
import 'package:linear/util/image_utils/image_premissions_util.dart';


typedef Future<bool> OnSaveImage(String url);

enum Source { GALLERY, CAMERA, NONE }
enum PickImageSource { GALLERY, CAMERA, BOTH }

class SingleImagePicker {
  final PickImageSource pickImageSource;
  final Function(String path) onImagePicked;
  final Function(String downloadUrl) onImageSuccessfullyUploaded;
  final OnSaveImage onSaveImage;
  final Function(String message) onImageUploadFailed;

  SingleImagePicker({
    this.pickImageSource = PickImageSource.BOTH,
    required this.onImagePicked,
    required this.onSaveImage,
    required this.onImageSuccessfullyUploaded,
    required this.onImageUploadFailed,
  });

  final ImagePicker imagePicker = ImagePicker();

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

      PickedFile? image = await imagePicker.getImage(source: imageSource);

      if (image != null) {
        onImagePicked.call(image.path);

        // String fileExtension = path.extension(image.path);

        SingleImageUtility singleImageUtility = SingleImageUtility();

        await singleImageUtility.generateUploadUrl();
        if (!singleImageUtility.isUploadUrlGenerated) {
          throw "Error generating upload url for your image!";
        }

        await singleImageUtility.uploadImage(image);
        if (!singleImageUtility.isImageUploaded) {
          throw "Error uploading your image!";
        }

        bool isSaved = await onSaveImage(singleImageUtility.downloadUrl);
        if (isSaved) {
          onImageSuccessfullyUploaded(singleImageUtility.downloadUrl);
        } else {
          throw "Failed to save image";
        }
      }
    } catch (e) {
      onImageUploadFailed(e.toString());
    }
  }
}