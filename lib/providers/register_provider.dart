import 'package:flutter/material.dart';
import 'package:tokoSM/services/register_service.dart';

class RegisterProvider with ChangeNotifier {
  late String _errorMessage;
  String get errorMessage => _errorMessage;

  Future<bool> postRegister({
    required String username,
    required String namaLengkap,
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> register = await RegisterService().register(
        username: username,
        namaLengkap: namaLengkap,
        email: email,
        password: password,
      );
      _errorMessage = register["message"];
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
}
