import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/cabang_model.dart';

class CabangService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<CabangModel> retrieveDataCabang({required String token}) async {
    var url = Uri.parse("${baseURL}pengaturan/cabang");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("cabang: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CabangModel cabang = CabangModel.fromJson(data);

      return cabang;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  Future<CabangModel> sendLatLonToGetDataCabang({
    required String token,
    required String lat,
    required String lon,
  }) async {
    var url = Uri.parse("${baseURL}pengaturan/cabang");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "lat": lat,
      "lon": lon,
    };

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: header,
      body: body,
    );
    // ignore: avoid_print
    print("data cabang terdekat: ${response.body}");

// **success melakukan get transaksi
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      var cabangModel = CabangModel.fromJson(data);
      return cabangModel;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
