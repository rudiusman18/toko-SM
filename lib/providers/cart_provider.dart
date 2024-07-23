import 'package:flutter/material.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  CartModel _cartModel = CartModel();
  CartModel get cartModel => _cartModel;
  set cartModel(CartModel cartModel) {
    _cartModel = cartModel;
    notifyListeners();
  }

  Future<bool> getCart({required String token}) async {
    try {
      CartModel cartModel = await CartService().retrieveCart(token: token);
      _cartModel = cartModel;
      print("berhasil mengambil cart");
      return true;
    } catch (e) {
      print("gagal mengambil cart $e");
      return false;
    }
  }

  Future<bool> postCart({
    required String token,
    required int cabangId,
    required int productId,
    int? jumlah,
    List<int>? multiSatuanJumlah,
    List<String>? multiSatuanunit,
    List<int>? jumlahMultiSatuan,
  }) async {
    try {
      await CartService().sendCart(
        token: token,
        cabangId: cabangId,
        productId: productId,
        jumlah: jumlah,
        multiSatuanJumlah: multiSatuanJumlah,
        multiSatuanunit: multiSatuanunit,
        jumlahMultiSatuan: jumlahMultiSatuan,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> postCart({required String token}) async {}

  Future<bool> updateCart({
    required String token,
    required String productId,
    required String jumlah,
  }) async {
    try {
      await CartService().updateCart(
        token: token,
        productId: productId,
        jumlah: jumlah,
      );
      print("sukses melakukan update cart");
      return true;
    } catch (e) {
      print("gagal melakukan update cart");
      return false;
    }
  }

  Future<bool> deleteCart({
    required String token,
    required String productId,
  }) async {
    try {
      await CartService().deleteCart(
        token: token,
        productId: productId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCatatanCart({
    required String token,
    required String productId,
    required String catatan,
  }) async {
    try {
      await CartService().updateCatatanCart(
        token: token,
        productId: productId,
        catatan: catatan,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
