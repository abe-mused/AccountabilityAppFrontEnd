import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:linear/constants/models/community.dart';
import 'package:linear/util/auth_util.dart';

Future<http.StreamedResponse> postCommunity(String communityName) async {
  final accessToken = await getAccessToken();
  var headers = {
    'Authorization':
        'eyJraWQiOiJ2R0dpb3N4R3ZoaUxBYlFISDMyYlwvUk15dzFvbzB0NFBRMFd1c1wvcUd3cW89IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1N2M4YmIyNS0xNTE0LTRmMjktYjRlYS0zYTE1Y2U5Zjk3ZGUiLCJkZXZpY2Vfa2V5IjoidXMtZWFzdC0xXzljOGE3MjQwLTZkN2ItNDFkZS1iNTI2LTllZTYxOGY4MTlhMSIsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy1lYXN0LTEuYW1hem9uYXdzLmNvbVwvdXMtZWFzdC0xXzB6d1htblFwTiIsImNsaWVudF9pZCI6IjFpcDBrdDNjOG9oc2h0NW9ndDZucjJ2OXFhIiwib3JpZ2luX2p0aSI6ImJmMGIzMWJlLTlmMjEtNGQ5Ny04NTJmLWI1OWQwMzFmZTJhMyIsImV2ZW50X2lkIjoiOTM5ZGIxYTktN2YxYi00ZmUzLWIwMmUtYzExYzdiNjEzNjkxIiwidG9rZW5fdXNlIjoiYWNjZXNzIiwic2NvcGUiOiJhd3MuY29nbml0by5zaWduaW4udXNlci5hZG1pbiIsImF1dGhfdGltZSI6MTY2NDM4OTI3NSwiZXhwIjoxNjY0NDc1Njc0LCJpYXQiOjE2NjQzODkyNzUsImp0aSI6IjkyYTYwOGQ3LWQyYWItNDAzMS1hMThhLThmZTliZjY2ZjQxYyIsInVzZXJuYW1lIjoiYWJlIn0.irlqxsWxAMkg_6eKA9NlWYNY9NDxPt2UPKYub6Nk-bJiLsSbTwNPKTHcWJ8eHU_2Rjj-2Mr41iRgEKsmULcBKrOT0BtWiKDkr2h8ePzOudHMJG51A99fwNwC7WHDuJlw1Vbfp2UP7ncLYHI7OhddVG7rw6jmGiVh5K5AbQaRlgZugBCkFpVNyklIPyhjj5nD1Lslh92-T1FUWWWl7P0jMnYt7gfOH0SSoYdJoPVoY61HsgWIA44rwwSqHKGCUlO8LTwqTUBWkMNcJ1sKzRzSVdUr93F5Sr9jP9zPs8zYO8Ax0HVzvU_QDjLts3Q6FusA1h6Sd_GL3zLbDuGvlBTz8w',
    'Content-Type': 'text/plain'
  };
  print(headers);
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

Future<Community> getCommunity(String communityName) async {
  final accessToken = await getAccessToken();
  var headers = {
    'Authorization':
        'eyJraWQiOiJFZnYyXC85TjJLRVc2OEtFODJoOXE0XC93SWV3emhBeFwvOXVYTkNLQmJ6eitFPSIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoiNDJXbUtCdTktMWItYTF4UFRTbGkzUSIsInN1YiI6IjU3YzhiYjI1LTE1MTQtNGYyOS1iNGVhLTNhMTVjZTlmOTdkZSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV8wendYbW5RcE4iLCJjb2duaXRvOnVzZXJuYW1lIjoiYWJlIiwiYXVkIjoiMWlwMGt0M2M4b2hzaHQ1b2d0Nm5yMnY5cWEiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTY2NDMxMzI3MiwiZXhwIjoxNjY0Mzk5NjcyLCJpYXQiOjE2NjQzMTMyNzIsImp0aSI6IjBkM2FlYTU0LTkyZWEtNDBkOC1hNjkyLTY5NGUzMzQ4YTJkOSIsImVtYWlsIjoiZWJyYWhhbW11c2VkQGdtYWlsLmNvbSJ9.j0zYpKtduKrYkFwNMViMRVWopsmdBoQzdVu1rV0jaRfjaXwduYek8wHCQcMXGw5kGwaH5A7l8FFejTIvsZ1NIv6k3-GCsp0VPWaOqygANj7QfSgyxRTOeBN13ffyq_MbTZqugpuQshr5XfGOibU86CN1U5S95kdF5My1cxVN0OCEYOtoJTXnz_GrvA54ct8ILBVdtKwEG9eCQC31N3W-lfHup831c4YOHuOw7mGF5RFwz-RzF9zY3A4QHSXpfeEeeY77cKpxvVx9eKG_sb3RmBKcGDJHQ76M6KUGeqPeMdLBiu0YxLxCw1PANxaB3UpsTigy7Qz1wMTqY1DhzdiA'
  };
  var request = await http.get(
      Uri.parse(
          'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community?&communityName=$communityName'),
      headers: headers);

  if (request.statusCode == 200) {
    //print(await response.stream.bytesToString());
    var some = json.decode(request.body);
    print('Tanvir Says: ' + some);
    return Community.fromJson(json.decode(request.body));
  } else {
    print('something went wrong');
    print(request.statusCode);
  }

  return Community(
      communityName: "error", creator: "error", creationDate: "error");
}
