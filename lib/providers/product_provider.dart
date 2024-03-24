import 'dart:ffi';

import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:tokoSM/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _wishlistData = [];
  List<ProductModel> get wishlistData => _wishlistData;

  set wishlistData(List<ProductModel> product) {
    _wishlistData = wishlistData;
    notifyListeners();
  }

  List<CartModel> _cartData = [];
  List<CartModel> get cartData => _cartData;

  set cartData(List<CartModel> product) {
    _cartData = cartData;
    notifyListeners();
  }

  late ProductModel _promoProduct;
  ProductModel get promoProduct => _promoProduct;
  set promoProduct(newPromoProduct) {
    _promoProduct = newPromoProduct;
    notifyListeners();
  }

  Future<bool> getPromoProduct({
    required String cabangId,
    required String token,
  }) async {
    try {
      ProductModel product = await ProductService().promoProduct(
        cabangId: cabangId,
        token: token,
      );
      _promoProduct = product;
      return true;
    } catch (e) {
      return false;
    }
  }
}
