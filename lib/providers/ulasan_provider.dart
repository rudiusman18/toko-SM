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

  Future<bool> getRiwayatUlasan(
      {required String token, String search = ""}) async {
    try {
      UlasanModel ulasanModel = await UlasanService()
          .retrieveRiwayatUlasan(token: token, search: search);
      _ulasanModel = ulasanModel;
      return true;
    } catch (e) {
      print("ada error ketika mendapatkan riwayat ulasan $e");
      return false;
    }
  }

  UlasanModel _ulasanProduct = UlasanModel();
  UlasanModel get ulasanProduct => _ulasanProduct;
  set ulasanProduct(UlasanModel newUlasanProduct) {
    _ulasanProduct = newUlasanProduct;
    notifyListeners();
  }

  Future<bool> getUlasanProduct(
      {required String token,
      required int productId,
      String rating = ""}) async {
    try {
      UlasanModel ulasanModel = await UlasanService().retrieveUlasanProduct(
          token: token, productId: productId, rating: rating);
      _ulasanProduct = ulasanModel;
      return true;
    } catch (e) {
      print("getUlasanProduct error dengan pesan: $e");
      return false;
    }
  }

  Future<bool> postUlasanProduct({
    required String token,
    required String invoice,
    required int productId,
    required String namaProduk,
    required int rating,
    required String ulasan,
  }) async {
    try {
      var data = await UlasanService().sendUlasan(
          token: token,
          invoice: invoice,
          productId: productId,
          namaProduk: namaProduk,
          rating: rating,
          ulasan: ulasan);
      print(
          "Sukses mengirimkan data ulasan $invoice, $productId, $namaProduk, $rating, $ulasan");
      return true;
    } catch (e) {
      return false;
    }
  }
}