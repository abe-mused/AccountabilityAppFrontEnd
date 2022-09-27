import 'package:http/http.dart' as http;
import 'package:linear/constants/models/community.dart';

Future<http.StreamedResponse> postCommunity(String communityName) async {
  var headers = {
    'Authorization':
        'eyJraWQiOiJFZnYyXC85TjJLRVc2OEtFODJoOXE0XC93SWV3emhBeFwvOXVYTkNLQmJ6eitFPSIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoia2U3ZUwyZkU4VDN0c2pQRGhMcEVvUSIsInN1YiI6IjY4YTRmMjRhLWMwMzItNGVhNi1hMzM3LTYwMWU4OGU1MGVhYSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV8wendYbW5RcE4iLCJjb2duaXRvOnVzZXJuYW1lIjoiYWJlIiwiYXVkIjoiMWlwMGt0M2M4b2hzaHQ1b2d0Nm5yMnY5cWEiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTY2NDIyNjI1NCwiZXhwIjoxNjY0MzEyNjU0LCJpYXQiOjE2NjQyMjYyNTQsImp0aSI6ImViZjI2YzMxLTQ3ZjktNGJlOC1iZDUwLWU1YjUxNDBlZGJkOCIsImVtYWlsIjoiZWJyYWhhbW11c2VkQGdtYWlsLmNvbSJ9.cdNpsfiofIjlldtaulwlLI5PS-SkSe1lSJ0CcxB9yCmSJ81K_om7R6nJQgvW5MVlIQZ8ExE5exX4ShuQWucGLEQsI9_ogFCdxtlzMEmx0ApI8BspRGUiQ7Y83rAyKj7ffGhyoSI0bwawwhThMZjyRhmjPWWF6U9MWEvOKWLMLqhPPjQBj177ei9iah0721n9LfDf-fmVPcP18k6PmlZmpym3dlA4x80DtC_0X4S_j4cWSc66VdqRQk-vAl-nh5Vq5hDz-s0oKQYJAmd97e8az3gEH0JNzyvZ5M8U5xV88sGGGbUKlmU6G2fLZ_CwlcL_XEkLsXEXjxWGSVhpAtAhHg',
    'Content-Type': 'text/plain'
  };
  var request = http.Request(
      'POST',
      Uri.parse(
          'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community'));
  request.body = '''{\r\n    "communityName": "$communityName"\r\n}''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
  return response;
}

Future<http.StreamedResponse> getCommunity(String communityName) async {
  var headers = {
    'Authorization':
        'eyJraWQiOiJFZnYyXC85TjJLRVc2OEtFODJoOXE0XC93SWV3emhBeFwvOXVYTkNLQmJ6eitFPSIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoia2U3ZUwyZkU4VDN0c2pQRGhMcEVvUSIsInN1YiI6IjY4YTRmMjRhLWMwMzItNGVhNi1hMzM3LTYwMWU4OGU1MGVhYSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV8wendYbW5RcE4iLCJjb2duaXRvOnVzZXJuYW1lIjoiYWJlIiwiYXVkIjoiMWlwMGt0M2M4b2hzaHQ1b2d0Nm5yMnY5cWEiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTY2NDIyNjI1NCwiZXhwIjoxNjY0MzEyNjU0LCJpYXQiOjE2NjQyMjYyNTQsImp0aSI6ImViZjI2YzMxLTQ3ZjktNGJlOC1iZDUwLWU1YjUxNDBlZGJkOCIsImVtYWlsIjoiZWJyYWhhbW11c2VkQGdtYWlsLmNvbSJ9.cdNpsfiofIjlldtaulwlLI5PS-SkSe1lSJ0CcxB9yCmSJ81K_om7R6nJQgvW5MVlIQZ8ExE5exX4ShuQWucGLEQsI9_ogFCdxtlzMEmx0ApI8BspRGUiQ7Y83rAyKj7ffGhyoSI0bwawwhThMZjyRhmjPWWF6U9MWEvOKWLMLqhPPjQBj177ei9iah0721n9LfDf-fmVPcP18k6PmlZmpym3dlA4x80DtC_0X4S_j4cWSc66VdqRQk-vAl-nh5Vq5hDz-s0oKQYJAmd97e8az3gEH0JNzyvZ5M8U5xV88sGGGbUKlmU6G2fLZ_CwlcL_XEkLsXEXjxWGSVhpAtAhHg'
  };
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community?&communityName=$communityName'));

  request.headers.addAll(headers);

  var response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }

  return response;
}
