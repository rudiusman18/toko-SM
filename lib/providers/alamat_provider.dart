import 'dart:ffi';

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

  Future<bool> postAlamat({
    required String token,
    required String namaAlamat,
    required String namaPenerima,
    required String telpPenerima,
    required String alamatLengkap,
    required String wilayah,
    required String kodePos,
    required String catatan,
    required double? lat,
    required double? lng,
  }) async {
    try {
      await AlamatService().sendNewAlamat(
        token: token,
        namaAlamat: namaAlamat,
        namaPenerima: namaPenerima,
        telpPenerima: telpPenerima,
        alamatLengkap: alamatLengkap,
        wilayah: wilayah,
        kodePos: kodePos,
        catatan: catatan,
        lat: lat,
        lng: lng,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  String _dataLatLong = "";
  String get dataLatLong => _dataLatLong;
  set dataLatLong(String dataLatLong) {
    _dataLatLong = dataLatLong;
    notifyListeners();
  }

  Future<bool> getLatLongData({
    required String token,
    required String userId,
  }) async {
    try {
      var data = await AlamatService()
          .retrieveLatLongData(token: token, userId: userId);
      _dataLatLong = "${data["lat"]},${data["lng"]}";
      return true;
    } catch (e) {
      return false;
    }
  }
}
