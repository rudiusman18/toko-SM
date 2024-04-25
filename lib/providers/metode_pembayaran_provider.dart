import 'package:flutter/material.dart';
import 'package:tokoSM/models/pembayaran_model.dart';
import 'package:tokoSM/services/metode_pembayaran_service.dart';

class MetodePembayaranProvider with ChangeNotifier {
  PembayaranModel _metodePembayaranModel = PembayaranModel();
  PembayaranModel get metodePembayaranModel => _metodePembayaranModel;
  set pembayaranModel(PembayaranModel pembayaranModel) {
    _metodePembayaranModel = pembayaranModel;
    notifyListeners();
  }

  Future<bool> getMetodePembayaran({
    required String token,
    required String cabangId,
  }) async {
    try {
      PembayaranModel metodePembayaranModel = await MetodePembayaranService()
          .retrieveMetodePembayaran(token: token, cabangId: cabangId);
      _metodePembayaranModel = metodePembayaranModel;
      return true;
    } catch (e) {
      return false;
    }
  }
}
