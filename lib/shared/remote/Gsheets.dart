
import 'package:gsheets/gsheets.dart';

import '../../model/user_model.dart';

class GoogleSheets {

  static const _spreadsheetId = '1v-NCPsYLnMOtWLBA0UXlcV_vjWA32saA7ZTiPOcdHdI';
 static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "blnk-user-info",
  "private_key_id": "577594a4175f0677da896e7e0f8f6851c2c6e434",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgsWmYwsLAATae\ndAhLF+U9N6dXQ5WOrEr7cq/QLbiXjZ/YUYkGWio2xx0eiB/nprp+zZLoYgVgkow+\nL3vjF7gUaaNRU8mV6jb46nFnqHoXSHP016+iaA4pvx9gWyqCIu89aGrQYYXtYMHy\nwq/O8e6xTU1r+r2C68xAu1hwScbyi82NVDqhJhvnUWmGCVEWxP5n/fVAo32gcuxA\nQDPf23K2/XkjOA/xMyyW9BgN/Vq3RS1cfTZXzcALNaqWFGTBQs0N9w4+sPToVAvN\nVsypEq3O9xqF0MAJc110ROTFblJgV/rA1IrcLKwN9pfIqrrrgjWl2Ys8GGcUSNTn\nMCdsnyuJAgMBAAECggEAAYEICg8Pm7gmTJICplyA/e4J4Wnr5mtq8KLqtO7uLLf2\ncpyxiF5QF8C+bYPavLRBDwZboo0YbbSmU7+CVX104oxb9dBzParRcEMvJ3Zm7yP+\nSKDQrZ7W9PxEQYL/mSzqq5O7vhfPXEY2sSxj5lZWVI2yvZqrg+QzBYgG7Gw96RT9\nkKHeo73CLtXOKvCk0/LxH1R9kRcG89VbGa+5bZo5/4X0c5IZTr82IgKoZ+PPCYNS\nz008L02dYOT9dluv3aUsZVYS1lN3vimb8CiKaMgNa2MkeK09HEFkneuQmCth4lv8\n5PCaobayTenp76i/Rlws7LEFSXzoSSl7JPa7rlvE8QKBgQDa0vXwhzUd6vJ29YkZ\n/YC6H+Yk9/N8/HSUcOxffwRj0QlK3j0u57+/3lPgTdLgllfEu4jzWuVMNfIaDiNP\nbasZ3TNTLA5Wi9iI70sLsYcM+lLfjkkz03YJ9voyNPXUUFZfZnad2JTzUmMcdwAr\nFiyn0K80gp7KWYpMagitvVi+0QKBgQC7/js8KTSR2seSd5XPo8gnBgqy4Tjrhj09\nKFXiyn23V9DMVuSo7wjJFnQMjw5L1NrjPyTCp/I8hP9Xmoy9hcAPlPCdl+hHz/UP\nrFDC3fnT2lkt0hhloFvTolAuP+jnV03Dy8Ttg2UTi8ZGXHg8VNSRlJ2oCg0rESaR\nQMESpMN/OQKBgB7BRbW/mxSQX/GeQt23Rm9ialtJyhwH826ljGNDm99XkuHF6H1+\nLvINkmZVKc1M9Br/bJkfbljOwC8vS4EvXbvt3ffTmlRJpW5hi3+iPOPzDtDC08EH\n+HAgGTwTO3XSsMEJyqQWu6CTNMDcbNahcDdJ2kYcEatI+GoTARNCKIXxAoGBAIXs\nt4ZEVI8TrNlLGA60PwKN61FD4ajoGPhYo9bNKoJSrQzlWkB/CWM3+7R2tViQat85\nPJbvzkIO/VkLYPgjMI/pKwEaFwARxiNEPsSUHkYuZxmdcoPzmXdLSpOoM+Oa7mtt\n3vzVfkxOZxH5Di7swAJ2PVpYzsi/jxorZ2BAwIUBAoGBAK9y7ucPzgpzXOMWDqw+\nsRirzhvw0BaZy+UZautTeucOW/V04VEHwrD5NCRRRdX2v8o05j9H8nX8Rh6vbo22\neVJ/8ENlWG1vM8NxNvv4XOEQtCiwcaDiLS0gyq99M5bXSLU/wiq9zo5CPLUOeidD\npwVw6hbpB8PXIN5tN7CMM+GX\n-----END PRIVATE KEY-----\n",
  "client_email": "blnk-user-info@blnk-user-info.iam.gserviceaccount.com",
  "client_id": "113206803013440484379",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/blnk-user-info%40blnk-user-info.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  static Worksheet? _userSheet;
  static final _gsheets = GSheets(_credentials);

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
       _userSheet = await _getWorkSheet(spreadsheet, title: 'Sheet1');
       final firstRow = UserFields.getFields();
       _userSheet!.values.insertRow(1, firstRow);
    }catch(e) {
      print(e);
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      { required String title}) async {

    try{
          return await spreadsheet.addWorksheet(title);
    } catch(e){
          return spreadsheet.worksheetByTitle(title)! ;
    }
  }

  static Future insertNewRow(List<Map<String, dynamic>> rowList) async {
    _userSheet!.values.map.appendRows(rowList);
  }

}

// var sheet = ss.worksheetByTitle('Sheet1') ;
// // add data to cell
// await sheet?.values!.insertValue('name', column: 1, row: 1);