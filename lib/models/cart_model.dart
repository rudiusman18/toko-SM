import 'package:e_shop/models/product_model.dart';
import 'package:flutter/material.dart';

class CartModel {
  ProductModel? product;
  int numberOfItem = 0;

  CartModel({this.product, required this.numberOfItem});
}