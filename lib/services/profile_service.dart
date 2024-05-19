import 'dart:convert';

import '../models/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<ProfileModel> retrieveProfile(
      {required String token, required String userId}) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}akun/profil?id=$userId");
    print("URL yang diakses adalah: ${url}");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("Product: ${response.body}");

// **success mendapatkan data profile
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      ProfileModel profile = ProfileModel.fromJson(data);
      return profile;
    } else {
      throw Exception("Gagal mendapatkan data profile");
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      {required String token,
      required int userId,
      required int cabangId,
      required String username,
      required String fullname,
      required String email,
      required String telp,
      required String alamat,
      required String wilayah,
      required String tglLahir,
      required String jenisKelamin}) async {
    var baseURL = "http://103.127.132.116/api/v1/";

    var url = Uri.parse("${baseURL}akun/profil?id=$userId");
    print("URL yang diakses adalah: ${url}");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map data = {
      "cabang_id": cabangId,
      "username": username,
      "nama_lengkap": fullname,
      "email": email,
      "telp": telp,
      "alamat": alamat,
      "wilayah": wilayah,
      "tgl_lahir": tglLahir,
      "jenis_kelamin": jenisKelamin,
    };

    var body = jsonEncode(data);

    var response = await http.put(url, headers: header, body: body);
    // ignore: avoid_print
    print("Profile: ${response.body}");

// **success mendapatkan data profile
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengupdate data profile");
    }
  }
}
