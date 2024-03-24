import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegisterService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<Map<String, dynamic>> register({
    required String username,
    required String namaLengkap,
    required String email,
    required String password,
  }) async {
    var url = Uri.parse("${baseURL}auth/register");
    var header = {
      'Content-Type': 'application/json',
    };
    Map data = {
      "username": username,
      "password": password,
      "email": email,
      "nama_lengkap": namaLengkap,
      "cabang_id": '1',
    };
    var body = jsonEncode(data);
    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("Login: ${response.body}");

// **success melakukan register
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
