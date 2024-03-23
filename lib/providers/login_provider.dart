import 'dart:convert';
import 'dart:ffi';

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

  // Setter getter untuk mendapatkan dan melakukan set email dan password yang ada di local
  late UserLocalModel _userLocal;
  UserLocalModel get userLocal => _userLocal;
  set userLocal(UserLocalModel newUserLocal) {
    _userLocal = newUserLocal;
    notifyListeners();
  }

  // Fungsi provider untuk digunakan di view
  Future<bool> postLogin(
      {required String email, required String password}) async {
    try {
      LoginModel login =
          await LoginService().login(email: email, password: password);
      _loginModel = login;
      await saveModelToPrefs(UserLocalModel(email: email, password: password));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Save model to SharedPreferences
  Future<void> saveModelToPrefs(UserLocalModel model) async {
    print(
        "isi konten yang akan disimpan adalah: ${model.email} dan ${model.password}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginData', jsonEncode(model.toJson()));
  }

  Future<UserLocalModel?> getModelFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('loginData');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      _userLocal = UserLocalModel.fromJson(jsonMap);
      return UserLocalModel.fromJson(jsonMap);
    } else {
      return null;
    }
  }
}
