import 'dart:ffi';

import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/detail_product_model.dart';
import 'package:tokoSM/models/favorite_model.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:tokoSM/models/suggestion_model.dart';
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

  ProductModel _product = ProductModel();
  ProductModel get product => _product;
  set product(ProductModel newProduct) {
    _product = newProduct;
    notifyListeners();
  }

  ProductModel _promoProduct = ProductModel();
  ProductModel get promoProduct => _promoProduct;
  set promoProduct(newPromoProduct) {
    _promoProduct = newPromoProduct;
    notifyListeners();
  }

  ProductModel _palingLarisProduct = ProductModel();
  ProductModel get palingLarisProduct => _palingLarisProduct;
  set palingLarisProduct(ProductModel newPalingLarisProduct) {
    _palingLarisProduct = newPalingLarisProduct;
    notifyListeners();
  }

  Future<bool> getProduct({
    required String cabangId,
    required String token,
    required String page,
    required String limit,
    required String sort,
  }) async {
    try {
      ProductModel product = await ProductService().product(
        cabangId: cabangId,
        token: token,
        page: page,
        limit: limit,
        sort: sort,
      );
      if (sort == "promo") {
        _promoProduct = product;
      } else if (sort == "terlaris") {
        _palingLarisProduct = product;
      } else {
        _product = product;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  late DetailProductModel _detailProductModel;
  DetailProductModel get detailProductModel => _detailProductModel;
  set detailProductModel(DetailProductModel newDetailProductModel) {
    _detailProductModel = newDetailProductModel;
  }

  Future<bool> getDetailProduct(
      {required String productId, required String token}) async {
    try {
      DetailProductModel detailProduct = await ProductService().detailProduct(
        productId: productId,
        token: token,
      );
      print("isi datanya adalah ${detailProduct.data?.id}");
      _detailProductModel = detailProduct;
      return true;
    } catch (e) {
      print(
          "detail product provider: $e dengan isi $productId dan ${productId.runtimeType}");
      return false;
    }
  }

  late Map<String, dynamic> _bannerProduct;
  Map<String, dynamic> get bannerProduct => _bannerProduct;
  set bannerProduct(Map<String, dynamic> newBannerProduct) {
    _bannerProduct = newBannerProduct;
    notifyListeners();
  }

  Future<bool> getBannerProduct({required String token}) async {
    try {
      Map<String, dynamic> bannerProduct =
          await ProductService().productBanner(token: token);
      _bannerProduct = bannerProduct;
      return true;
    } catch (e) {
      print("getBannerProduct : Product Provider error: $e");
      return false;
    }
  }

  late FavoriteModel _favoriteModel;
  FavoriteModel get favoriteModel => _favoriteModel;
  set favoriteModel(FavoriteModel newFavoriteModel) {
    _favoriteModel = newFavoriteModel;
    notifyListeners();
  }

  Future<bool> postFavoriteProduct(
      {required String token, required String productId}) async {
    try {
      await ProductService().sendFavoriteProduct(
        productId: productId,
        token: token,
      );
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> getFavoriteProduct({
    String page = "",
    String limit = "",
    required String token,
  }) async {
    try {
      FavoriteModel favoriteModel =
          await ProductService().retrieveFavoriteProduct(
        token: token,
        page: page,
        limit: limit,
      );
      _favoriteModel = favoriteModel;
      return true;
    } catch (e) {
      throw Exception("retrieve favorite product failed: $e");
    }
  }

  Future<bool> deleteFavoriteProduct({
    required String token,
    required String productId,
  }) async {
    try {
      await ProductService().removeFavoriteProduct(
        token: token,
        productId: productId,
      );
      return true;
    } catch (e) {
      throw Exception("gagal menghapus favorite product: $e");
    }
  }

  SuggestionModel _suggestionModel = SuggestionModel();
  SuggestionModel get suggestionModel => _suggestionModel;
  set suggestionModel(SuggestionModel suggestionModel){
    _suggestionModel = suggestionModel;
    notifyListeners();
  }

  Future<bool>getSuggestion({required String token}) async{
    try{
       SuggestionModel suggestionModel = await ProductService().suggestion(token: token);
      _suggestionModel = suggestionModel;
      return true;
    }catch(e){
      print("Gagal mendapatkan suggestion: $e");
      return false;
    }
  }
}
