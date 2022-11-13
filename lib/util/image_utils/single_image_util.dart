import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer' as developer;

class SingleImageUtility {
  bool isUploadUrlGenerated = false;
  String uploadUrl = '';
  String downloadUrl = '';
  String fileName = '';

  bool isImageUploaded = false;

  Future<void> generateUploadUrl(String token) async {
    try {
      var response = await http.get(
        Uri.parse('https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post/image'),
          headers: {
          "Authorization": token,
          "Content-Type": "application/json",
        },
        );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        isUploadUrlGenerated = true;
        uploadUrl = result["uploadUrl"];
        fileName = result["fileName"];
        downloadUrl = result["downloadUrl"];
      }
    } catch (e) {
      throw ('Error generating an upload url!');
    }
  }

  Future<void> uploadImage(PickedFile image) async {
    if(isImageUploaded){
      throw 'ERROR: `uploadImage` called more than once for the same link.';
    }
    if(!isUploadUrlGenerated){
      throw 'ERROR: `uploadImage` called before `generateUploadUrl`.';
    }

    try {
      Uint8List bytes = await image.readAsBytes();
      var response = await http.put(
        Uri.parse(uploadUrl),
        body: bytes,
        headers: {
          "Content-Type": "image/jpeg",
        },
        );

      if (response.statusCode == 200) {
        isImageUploaded = true;
      }
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}