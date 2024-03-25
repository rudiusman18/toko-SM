import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokoSM/models/product_model.dart';

import '../models/detail_product_model.dart';

class ProductService {
  Future<ProductModel> promoProduct({
    required String cabangId,
    required String token,
  }) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}produk/promo?cabang=$cabangId");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Product: ${response.body}");

// **success mendapatkan data produk
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      ProductModel product = ProductModel.fromJson(data);
      return product;
    } else {
      throw Exception("Gagal mendapatkan data produk");
    }
  }

  Future<DetailProductModel> detailProduct({required String productId, required String token})async{
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}produk/detail/$productId");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Detail Product: ${response.body}");

// **success mendapatkan data produk
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      DetailProductModel detailProduct = DetailProductModel.fromJson(data);
      return detailProduct;
    } else {
      throw Exception("Gagal mendapatkan detail data produk");
    }
  }
}
