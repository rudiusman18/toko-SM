import 'package:flutter/cupertino.dart';
import 'package:tokoSM/models/alamat_model.dart';
import 'package:tokoSM/services/alamat_service.dart';

class AlamatProvider with ChangeNotifier {
  AlamatModel _alamatModel = AlamatModel();
  AlamatModel get alamatModel => _alamatModel;
  set alamatModel(AlamatModel alamatModel) {
    _alamatModel = alamatModel;
    notifyListeners();
  }

  AlamatModel _deliveryAlamat = AlamatModel();
  AlamatModel get deliveryAlamat => _deliveryAlamat;
  set deliveryAlamat(AlamatModel deliveryAlamat) {
    _deliveryAlamat = deliveryAlamat;
    notifyListeners();
  }

  Future<bool> getAlamat({required String token}) async {
    try {
      AlamatModel alamatModel =
          await AlamatService().retrieveAlamat(token: token);
      _alamatModel = alamatModel;
      return true;
    } catch (e) {
      print("Alamat: $e");
      return false;
    }
  }
}
