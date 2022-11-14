import 'package:flutter/material.dart';
import 'package:linear/pages/image_related_widgets/single_image_picker.dart';

enum PhotoStatus { LOADING, ERROR, LOADED, NONE }

class UploadImageWidget extends StatefulWidget {
  UploadImageWidget(
      {super.key,
      required this.token,
      required this.onSuccess});
  
  String token;
  final Function onSuccess;
  
  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  PhotoStatus photoStatus = PhotoStatus.NONE;
  String source = "";

  Future<bool> onSaved(String url){
    print("on save image: $url");
    widget.onSuccess(url);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.grey.shade200,
                child: photoStatus == PhotoStatus.LOADED
                    ? Image.network(source, height: 200)
                      : Container(color: Colors.grey.shade200, height: 200),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: photoStatus == PhotoStatus.LOADING
                  ? const CircularProgressIndicator()
                  : photoStatus == PhotoStatus.ERROR
                      ? const Icon(Icons.error, color: Colors.red, size: 40)
                      : photoStatus == PhotoStatus.NONE
                        ? _buildAddPhotoButton()
                        : Container(),
            )
          ],
        ),
      )
    );
  }

  _buildAddPhotoButton() {
    return TextButton(
        onPressed: () async {
          final SingleImagePicker picker = SingleImagePicker(
            token: widget.token,
            pickImageSource: PickImageSource.BOTH,
            onImagePicked: (path) => {
              setState(() {
                photoStatus = PhotoStatus.LOADING;
                source = path;
              })
            },
            onSaveImage: onSaved,
            onImageSuccessfullyUploaded: (downloadUrl) => {
              setState(() {
                photoStatus = PhotoStatus.LOADED;
                source = downloadUrl;
              })
            },
            onImageUploadFailed: (message) => {
              setState(() {
                photoStatus = PhotoStatus.ERROR;
              }),
            },
          );
          picker.pickImage(context);
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
}