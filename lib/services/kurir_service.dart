import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokoSM/models/cabang_model.dart';
import 'package:tokoSM/models/kurir_model.dart';

class KurirService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<KurirModel> retrieveKurir(
      {required String token, required String cabangId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DataCabang cabangterpilih = DataCabang();
    if (prefs.getString("cabangterpilih") != null) {
      cabangterpilih = DataCabang.fromJson(
          jsonDecode(prefs.getString("cabangterpilih") ?? ""));
    }
    var url = Uri.parse(
        "${baseURL}pengaturan/kurir?cabang=${cabangterpilih.id ?? cabangId}");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("kurir: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      KurirModel kurir = KurirModel.fromJson(data);

      return kurir;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
