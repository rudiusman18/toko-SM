import "package:flutter/material.dart";
import "package:tokoSM/models/ulasan_model.dart";
import "package:tokoSM/services/ulasan_service.dart";

class UlasanProvider with ChangeNotifier {
  UlasanModel _ulasanModel = UlasanModel();
  UlasanModel get ulasanModel => _ulasanModel;
  set ulasanModel(UlasanModel newUlasanModel) {
    _ulasanModel = newUlasanModel;
    notifyListeners();
  }

  Future<bool> getRiwayatUlasan({required String token}) async {
    try {
      UlasanModel ulasanModel =
          await UlasanService().retrieveRiwayatUlasan(token: token);
      _ulasanModel = ulasanModel;
      return true;
    } catch (e) {
      print("ada error ketika mendapatkan riwayat ulasan $e");
      return false;
    }
  }
}
