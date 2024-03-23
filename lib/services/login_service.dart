import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:tokoSM/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<LoginModel> login(
      {required String email, required String password}) async {
    var url = Uri.parse("${baseURL}auth/login");
    var header = {'Content-Type': 'application/json'};
    Map data = {"email": email, "password": password};
    var body = jsonEncode(data);
    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("Login: ${response.body}");

// **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      LoginModel login = LoginModel.fromJson(data);
      return login;
    } else {
      throw Exception("Gagal Login");
    }
  }
}
