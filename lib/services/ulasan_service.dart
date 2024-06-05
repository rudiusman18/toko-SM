import "dart:convert";

import "package:flutter/material.dart";
import "package:tokoSM/models/ulasan_model.dart";
import "package:http/http.dart" as http;

class UlasanService {
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<UlasanModel> retrieveRiwayatUlasan(
      {required String token, String search = ""}) async {
    var url = Uri.parse("${baseURL}ulasan?q=$search");
    print("URL yang diakses adalah: ${url}");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Ulasan: ${response.body}");

// **success mendapatkan data ulasan
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      UlasanModel ulasan = UlasanModel.fromJson(data);
      return ulasan;
    } else {
      throw Exception("Gagal mendapatkan data riwayat ulasan");
    }
  }

  Future<UlasanModel> retrieveUlasanProduct(
      {required String token,
      required int productId,
      String rating = ""}) async {
    var url = Uri.parse("${baseURL}produk/ulasan/$productId?rating=$rating");
    print("URL yang diakses adalah: ${url}");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Ulasan Produk: ${response.body}");

// **success mendapatkan data ulasan
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      UlasanModel ulasan = UlasanModel.fromJson(data);
      return ulasan;
    } else {
      throw Exception("Gagal mendapatkan data ulasan produk");
    }
  }

  Future<Map<String, dynamic>> sendUlasan({
    required String token,
    required int productId,
    required String namaProduk,
    required int rating,
    required String ulasan,
  }) async {
    var url = Uri.parse("${baseURL}ulasan");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "produk_id": productId,
      "nama_produk": namaProduk,
      "rating": rating,
      "ulasan": ulasan,
    };

    var body = jsonEncode(data);

    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print(
        "ulasan: ${response.body} dengan ${productId} dan $namaProduk $rating $ulasan");

// **success melakukan post Ulasan
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
