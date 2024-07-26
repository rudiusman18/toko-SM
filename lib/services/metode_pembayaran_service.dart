import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokoSM/models/cabang_model.dart';
import 'package:tokoSM/models/pembayaran_model.dart';

class MetodePembayaranService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<PembayaranModel> retrieveMetodePembayaran(
      {required String token, required String cabangId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DataCabang cabangterpilih = DataCabang.fromJson(
        jsonDecode(prefs.getString("cabangterpilih") ?? ""));
    var url = Uri.parse(
        "${baseURL}pengaturan/pembayaran?cabang=${cabangterpilih.id ?? cabangId}");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("pembayaran: ${response.body}");

// **success melakukan get pembayaran
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      PembayaranModel pembayaranModel = PembayaranModel.fromJson(data);

      return pembayaranModel;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
