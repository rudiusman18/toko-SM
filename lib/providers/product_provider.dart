import 'package:e_shop/models/cart_model.dart';
import 'package:e_shop/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier{
    List <ProductModel> _wishlistData = [];
    List <ProductModel> get wishlistData => _wishlistData;

    set wishlistData(List <ProductModel> product){
      _wishlistData = wishlistData;
      notifyListeners();
    }

    List <CartModel> _cartData = [];
    List <CartModel> get cartData => _cartData;

    set cartData(List <CartModel> product){
      _cartData = cartData;
      notifyListeners();
    }
}