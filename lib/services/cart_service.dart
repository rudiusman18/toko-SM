import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:tokoSM/models/cart_model.dart';
import 'package:http/http.dart' as http;

class CartService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<CartModel> retrieveCart({required String token}) async {
    var url = Uri.parse("${baseURL}keranjang");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("cart: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CartModel cart = CartModel.fromJson(data);

      return cart;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  Future<Map<String, dynamic>> sendCart(
      {required String token,
      required int cabangId,
      required int productId}) async {
    var url = Uri.parse("${baseURL}keranjang");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "cabang_id": cabangId,
      "produk_id": productId,
    };

    var body = jsonEncode(data);

    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("cart: ${response.body}");

// **success melakukan post cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  Future<Map<String, dynamic>> updateCart({
    required String token,
    required String productId,
    required String jumlah,
  }) async {
    var url = Uri.parse("${baseURL}keranjang/$productId");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "jumlah": int.parse(jumlah),
    };

    var body = jsonEncode(data);

    var response = await http.put(
      url,
      headers: header,
      body: body,
    );
    // ignore: avoid_print
    print("cart: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  Future<Map<String, dynamic>> deleteCart(
      {required String token, required String productId}) async {
    var url = Uri.parse("${baseURL}keranjang/$productId");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.delete(url, headers: header);
    // ignore: avoid_print
    print("cart: ${response.body}");

// **success melakukan delete cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  Future<Map<String, dynamic>> updateCatatanCart({
    required String token,
    required String productId,
    required String catatan,
  }) async {
    var url = Uri.parse("${baseURL}keranjang/$productId");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "catatan": catatan,
    };

    var body = jsonEncode(data);

    var response = await http.put(
      url,
      headers: header,
      body: body,
    );
    // ignore: avoid_print
    print("catatan: ${response.body}");

// **success melakukan update catatan
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
