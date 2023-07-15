import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:path_provider/path_provider.dart';
class PhotoUploader {
  static Future<void> uploadImageToDrive(File imageFile) async {
    // Load the service account credentials
    //String clintId = 'https://drive.google.com/drive/folders/11Z6UW-Rq892y2vxhOBTPQdI2AN4InxVs?usp=sharing';
    final serviceAccountJson = '''
    {
  "type": "service_account",
  "project_id": "blnk-user-info",
  "private_key_id": "577594a4175f0677da896e7e0f8f6851c2c6e434",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgsWmYwsLAATae\\ndAhLF+U9N6dXQ5WOrEr7cq/QLbiXjZ/YUYkGWio2xx0eiB/nprp+zZLoYgVgkow+\\nL3vjF7gUaaNRU8mV6jb46nFnqHoXSHP016+iaA4pvx9gWyqCIu89aGrQYYXtYMHy\\nwq/O8e6xTU1r+r2C68xAu1hwScbyi82NVDqhJhvnUWmGCVEWxP5n/fVAo32gcuxA\\nQDPf23K2/XkjOA/xMyyW9BgN/Vq3RS1cfTZXzcALNaqWFGTBQs0N9w4+sPToVAvN\\nVsypEq3O9xqF0MAJc110ROTFblJgV/rA1IrcLKwN9pfIqrrrgjWl2Ys8GGcUSNTn\\nMCdsnyuJAgMBAAECggEAAYEICg8Pm7gmTJICplyA/e4J4Wnr5mtq8KLqtO7uLLf2\\ncpyxiF5QF8C+bYPavLRBDwZboo0YbbSmU7+CVX104oxb9dBzParRcEMvJ3Zm7yP+\\nSKDQrZ7W9PxEQYL/mSzqq5O7vhfPXEY2sSxj5lZWVI2yvZqrg+QzBYgG7Gw96RT9\\nkKHeo73CLtXOKvCk0/LxH1R9kRcG89VbGa+5bZo5/4X0c5IZTr82IgKoZ+PPCYNS\\nz008L02dYOT9dluv3aUsZVYS1lN3vimb8CiKaMgNa2MkeK09HEFkneuQmCth4lv8\\n5PCaobayTenp76i/Rlws7LEFSXzoSSl7JPa7rlvE8QKBgQDa0vXwhzUd6vJ29YkZ\\n/YC6H+Yk9/N8/HSUcOxffwRj0QlK3j0u57+/3lPgTdLgllfEu4jzWuVMNfIaDiNP\\nbasZ3TNTLA5Wi9iI70sLsYcM+lLfjkkz03YJ9voyNPXUUFZfZnad2JTzUmMcdwAr\\nFiyn0K80gp7KWYpMagitvVi+0QKBgQC7/js8KTSR2seSd5XPo8gnBgqy4Tjrhj09\\nKFXiyn23V9DMVuSo7wjJFnQMjw5L1NrjPyTCp/I8hP9Xmoy9hcAPlPCdl+hHz/UP\\nrFDC3fnT2lkt0hhloFvTolAuP+jnV03Dy8Ttg2UTi8ZGXHg8VNSRlJ2oCg0rESaR\\nQMESpMN/OQKBgB7BRbW/mxSQX/GeQt23Rm9ialtJyhwH826ljGNDm99XkuHF6H1+\\nLvINkmZVKc1M9Br/bJkfbljOwC8vS4EvXbvt3ffTmlRJpW5hi3+iPOPzDtDC08EH\\n+HAgGTwTO3XSsMEJyqQWu6CTNMDcbNahcDdJ2kYcEatI+GoTARNCKIXxAoGBAIXs\\nt4ZEVI8TrNlLGA60PwKN61FD4ajoGPhYo9bNKoJSrQzlWkB/CWM3+7R2tViQat85\\nPJbvzkIO/VkLYPgjMI/pKwEaFwARxiNEPsSUHkYuZxmdcoPzmXdLSpOoM+Oa7mtt\\n3vzVfkxOZxH5Di7swAJ2PVpYzsi/jxorZ2BAwIUBAoGBAK9y7ucPzgpzXOMWDqw+\\nsRirzhvw0BaZy+UZautTeucOW/V04VEHwrD5NCRRRdX2v8o05j9H8nX8Rh6vbo22\\neVJ/8ENlWG1vM8NxNvv4XOEQtCiwcaDiLS0gyq99M5bXSLU/wiq9zo5CPLUOeidD\\npwVw6hbpB8PXIN5tN7CMM+GX\\n-----END PRIVATE KEY-----\\n",
  "client_email": "blnk-user-info@blnk-user-info.iam.gserviceaccount.com",
  "client_id": "113206803013440484379",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/blnk-user-info%40blnk-user-info.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

    final credentials = auth.ServiceAccountCredentials.fromJson(
        serviceAccountJson);


    // Authenticate using the credentials
    final httpClient = await auth.clientViaServiceAccount(credentials, [
      drive.DriveApi.driveFileScope,
    ]);

    try {
      // Initialize the Drive API
      final driveApi = drive.DriveApi(httpClient);

      // Get the app document directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final appDocPath = appDocDir.path;

      // Generate a unique file name for the uploaded image
      final fileName = 'image_${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg';

      // Create a new file in Drive
      final file = drive.File()
        ..name = fileName
        ..parents = ['https://drive.google.com/uc?export=view&id=11Z6UW-Rq892y2vxhOBTPQdI2AN4InxVs'];

      // Upload the image file to Drive
      await driveApi.files.create(
        file,
        uploadMedia: drive.Media(
          http.ByteStream(imageFile.openRead()),
          imageFile.lengthSync(),
        ),
      );

      print('Image uploaded successfully!');
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      // Close the HTTP client to release resources
      httpClient.close();
    }
  }
}





// import 'dart:convert';
// import 'dart:io';
//
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:path/path.dart';
//
//
// class PhotoService {
//   final String clientId = '281612383864-6t4melfq7ecg0b5uqti5p2jl3uheh5e8.apps.googleusercontent.com';
//   final List<String> _scopes = ['https://www.googleapis.com/auth/photoslibrary'];
//
//   Future<AuthClient> getHttpClient() async {
//     AuthClient authClient = await clientViaUserConsent(ClientId(clientId), _scopes,prompt);
//     return authClient;
//   }
//
//   Future<void> upload(File file) async {
//     final client = await getHttpClient();
//
//     final uploadUrlResponse = await client.post(Uri.parse('https://photoslibrary.googleapis.com/v1/uploads'), body: file.readAsBytesSync());
//     final uploadToken = uploadUrlResponse.body;
//
//     final createMediaItemResponse = await client.post(
//       Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate'),
//       headers: {
//         'Content-type': 'application/json',
//       },
//       body: jsonEncode({
//         'newMediaItems': [
//           {
//             'description': 'item-description',
//             'simpleMediaItem': {
//               'uploadToken': uploadToken,
//               'fileName': basename(file.path),
//             },
//           },
//         ],
//       }),
//     );
//
//     print(createMediaItemResponse.body);
//   }
//
//   void prompt(String url) {
//     // Handle user consent URL, you can open it in a web view or external browser.
//   }
// }


// import 'dart:convert';
// import 'dart:io';
//
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart';
// // import other necessary packages
//
// class PhotoService {
//   String clientId = '281612383864-6t4melfq7ecg0b5uqti5p2jl3uheh5e8.apps.googleusercontent.com';
//   final List<String> _scopes = ['http://www.googleapis.com/auth/photolibrary'];
//
//   Future<AuthClient> getHttpClient() async {
//     AuthClient authClient = await clientViaUserConsent(ClientId(clientId), _scopes, _userPrompt);
//     return authClient;
//   }
//
//   upload(File file) async {
//     try {
//       AuthClient client = await getHttpClient();
//       var tokenResult = await client.post(Uri.parse('http://www.googleapis.com/v1/upload'),
//         headers: {
//           'Content-type': 'application/octet-stream',
//           'X-Goog-Upload-content-Type': 'image/png',
//           'X-Goog-Upload-Protocol': 'raw'
//         },
//         body: file.readAsBytesSync(),
//       );
//
//       var res = await client.post(Uri.parse('https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate'),
//         headers: {
//           'Content-type': 'application/json'
//         },
//         body: jsonEncode({
//           "newMediaItems": [
//             {
//               "description": "item-description",
//               "simpleMediaItem": {
//                 "fileName": "flutter-photos-upload",
//                 "uploadToken": tokenResult.body,
//               }
//             }
//           ]
//         }),
//       );
//       print(res.body);
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//
//   _userPrompt(String url) {
//     // Uncomment and implement the method to launch the URL in a browser or WebView
//     // launch(url);
//   }
// }
