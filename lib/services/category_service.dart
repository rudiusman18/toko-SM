import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tokoSM/models/category_model.dart';

class CategoryService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<CategoryModel> category({required String token}) async {
    var url = Uri.parse("${baseURL}produk/kategori?tree=1");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("category: ${response.body}");

// **success melakukan get category
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      CategoryModel category = CategoryModel.fromJson(data);

      return category;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
