import 'dart:convert';
import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/models/user_local_model.dart';
import 'package:tokoSM/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  late LoginModel _loginModel;
  // Mengatur getter untuk login model
  LoginModel get loginModel => _loginModel;
  // Mengatur setter untuk login model
  set loginModel(LoginModel login) {
    _loginModel = login;
    notifyListeners();
  }

  // Fungsi provider untuk digunakan di view
  Future<bool> postLogin(
      {required String email, required String password}) async {
    try {
      LoginModel login =
          await LoginService().login(email: email, password: password);
      _loginModel = login;
      await saveModelToPrefs(_loginModel);
      return true;
    } catch (e) {
      print("postLogin gagal dengan pesan $e");
      return false;
    }
  }

  // Save model to SharedPreferences
  Future<void> saveModelToPrefs(LoginModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginData', jsonEncode(model.toJson()));
  }

  Future<LoginModel?> getModelFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('loginData');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      _loginModel = LoginModel.fromJson(jsonMap);
      return LoginModel.fromJson(jsonMap);
    } else {
      return null;
    }
  }
}
