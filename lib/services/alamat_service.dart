import 'dart:convert';
import 'dart:ffi';
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

  // Fungsi untuk mengambil data latitude dan longitude pada maps webview
  Future<Map<String, dynamic>> retrieveLatLongData({
    required String token,
    required String userId,
  }) async {
    var url = Uri.parse("https://103.127.132.116/api/v2/map/customer/$userId");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("alamat: ${response.body}");

// **success melakukan get data lat long
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Gagal mendapatkan data latlong");
    }
  }

  Future<Map<String, dynamic>> sendNewAlamat({
    required String token,
    required String namaAlamat,
    required String namaPenerima,
    required String telpPenerima,
    required String alamatLengkap,
    required String wilayah,
    required String kodePos,
    required String catatan,
    required double? lat,
    required double? lng,
  }) async {
    var url = Uri.parse("${baseURL}akun/alamat");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "nama_alamat": namaAlamat,
      "nama_penerima": namaPenerima,
      "telp_penerima": telpPenerima,
      "alamat_lengkap": alamatLengkap,
      "wilayah": wilayah,
      "kodepos": kodePos,
      "catatan": catatan,
      "lat": lat,
      "lng": lng
    };

    var body = jsonEncode(data);

    var response = await http.post(url, headers: header, body: body);
    // ignore: avoid_print
    print("newAlamat: ${response.statusCode} ${response.body}");

    print("newAlamat sebelum dikirim: ${data}");

// **success melakukan post cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
