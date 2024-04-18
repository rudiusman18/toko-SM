import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokoSM/models/favorite_model.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:tokoSM/models/suggestion_model.dart';

import '../models/detail_product_model.dart';

class ProductService {
  Future<ProductModel> product({
    required String cabangId,
    required String token,
    required String page,
    required String limit,
    required String sort,
  }) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse(
        "${baseURL}produk?cabang=$cabangId&page=$page&limit=$limit&sort=$sort");
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

  Future<DetailProductModel> detailProduct(
      {required String productId, required String token}) async {
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
      throw Exception(
          "Gagal mendapatkan detail data produk dengan isi ${response.body}");
    }
  }

  Future<Map<String, dynamic>> productBanner({required String token}) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}produk/banner");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Banner Product: ${response.body}");

// **success mendapatkan data banner produk
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("product banner error: ${jsonDecode(response.body)}");
    }
  }

  Future<Map<String, dynamic>> sendFavoriteProduct(
      {required String productId, required String token}) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}favorit");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map data = {
      "id": productId,
    };
    var body = jsonEncode(data);
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );
    // ignore: avoid_print
    print("post favorite item: ${response.body}");

// **success melakukan post favorite item
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          "gagal mengirimkan favorite item error: ${jsonDecode(response.body)}");
    }
  }

  Future<FavoriteModel> retrieveFavoriteProduct({
    String limit = "",
    String page = "",
    required String token,
  }) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}favorit?limit=$limit&page=$page");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("get favorite product: ${response.body}");

// **success mendapatkan data favorite product
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      FavoriteModel favoriteModel = FavoriteModel.fromJson(data);
      return favoriteModel;
    } else {
      throw Exception(
          "gagal mendapatkan data favorite product error: ${jsonDecode(response.body)}");
    }
  }

  Future<Map<String, dynamic>> removeFavoriteProduct({
    required String token,
    required String productId,
  }) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}favorit/$productId");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.delete(url, headers: header);
    // ignore: avoid_print
    print("delete favorite product: ${response.body}");

// **success menghapus data favorite product
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          "gagal menghapus data favorite product error: ${jsonDecode(response.body)}");
    }
  }

  Future<SuggestionModel> suggestion({required String token})async{
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}produk/suggestion");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("suggestion: ${response.body}");

// **success menghapus data favorite product
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      SuggestionModel suggestionModel = SuggestionModel.fromJson(data);
      return suggestionModel;
    } else {
      throw Exception("Gagal mendapatkan data suggestion");
    }
  }
}
