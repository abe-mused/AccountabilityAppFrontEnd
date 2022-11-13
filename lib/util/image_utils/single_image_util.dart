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

  Future<void> generateUploadUrl() async {
    //TODO: remove hard-coded token
    String token = "eyJraWQiOiJFZnYyXC85TjJLRVc2OEtFODJoOXE0XC93SWV3emhBeFwvOXVYTkNLQmJ6eitFPSIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoiV1FYNmFzWDhERGxyS1dHZ1hfbzJCZyIsInN1YiI6ImRkOGQzYjYwLWI0NzUtNDNiZC04OTUyLTI3Zjk3MDJiOThiZiIsImF1ZCI6IjFpcDBrdDNjOG9oc2h0NW9ndDZucjJ2OXFhIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNjY4MzA5MjA4LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV8wendYbW5RcE4iLCJjb2duaXRvOnVzZXJuYW1lIjoibW9oYW1tZWRhbGkiLCJleHAiOjE2NjgzOTU2MDgsImlhdCI6MTY2ODMwOTIwOCwiZW1haWwiOiJneDAzNDBAd2F5bmUuZWR1In0.QeJS_IqmwYHozbQZNl2k3v33DADEvg1pnV_gJ4uDWzLdvvBQFOpHmP8qu8bqZ-f_pE2yfC0w9B64BlUNeA5NubN61tCtqHs2jTp7DWBTzgRQVu5WmZyq-aU1xOcKvwC6FxYtOV1ReBYZiV5B1hyvXmdGkC5socPkEfNZ3dTxMDgXyGciVicmDHR8KuVa748sNoeYl4y4kTb8oilSdsfb9bBXmrsNMVgogZTSb6CXHt89AnNR6bQwLzLKtBj7GPLQ3o5ZEPlRMSFTBxxMCHDchiFaI-EfaL7SDA8bl2PXtJl2zJRnS3wLMtXW2viBmBENT0faBayuGuEpqULUs60L7g";
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
      developer.log('WARNING: `uploadImage` called before `generateUploadUrl`.');
      await generateUploadUrl();
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