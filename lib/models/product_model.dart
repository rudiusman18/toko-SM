import 'package:flutter/material.dart';

class ProductModel{
  String? productName;
  String? urlImg;
  String? productPrice;
  String? beforeDiscountPrice;
  String? discountPercentage;
  bool? isDiscount;
  bool? isFavorite;
  bool? isAddtoCart;

  ProductModel({this.productName, this.urlImg, this.productPrice, this.beforeDiscountPrice, this.discountPercentage, this.isFavorite, this.isAddtoCart, this.isDiscount});
}

