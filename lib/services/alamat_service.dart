import 'dart:convert';
import 'dart:io';

import 'package:tokoSM/models/alamat_model.dart';
import 'package:http/http.dart' as http;

class AlamatService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<AlamatModel> retrieveAlamat({required String token}) async {
    var url = Uri.parse("${baseURL}akun/alamat");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("alamat: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      AlamatModel alamat = AlamatModel.fromJson(data);

      return alamat;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
