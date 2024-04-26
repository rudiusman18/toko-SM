import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tokoSM/models/cart_model.dart';

import '../models/transaction_model.dart';

class TransaksiService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<Map<String, dynamic>> sendTransaksi({
    required String token,
    required int pelangganId,
    required int cabangId,
    required int pengirimanId,
    required int kurirId,
    required String namaKurir,
    required int totalHarga,
    required int totalOngkosKirim,
    required int totalBelanja,
    required String metodePembayaran,
    required String namaPenerima,
    required String alamatPenerima,
    required String banktransfer,
    required String noRekeningTransfer,
    required List<DataKeranjang> product,
  }) async {
    var url = Uri.parse("${baseURL}transaksi");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "pelanggan_id": pelangganId,
      "cabang_id": cabangId,
      "kurir_id": kurirId,
      "pengiriman_id": pengirimanId, // id alamat pengiriman
      "nama_kurir": namaKurir,
      "total_harga": totalHarga,
      "total_ongkos_kirim": totalOngkosKirim,
      "total_belanja": totalBelanja,
      "metode_pembayaran": metodePembayaran,
      "nama_penerima": namaPenerima, // nama dari id alamat pengiriman
      "alamat_penerima": alamatPenerima, // alamat dari id alamat pengiriman
      "bank_transfer": banktransfer,
      "norekening_transfer": noRekeningTransfer,
      "produk": generateProducts(initProducts: product)
    };

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: header,
      body: body,
    );
    // ignore: avoid_print
    print("transaksi: ${response.body}");

// **success melakukan get transaksi
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  List<Map<String, dynamic>> generateProducts({required List<DataKeranjang> initProducts}) {
    // Create a list to hold the dynamic products
    List<Map<String, dynamic>> products = [];

    // Convert Product objects to Map and add them to the list
    for (DataKeranjang product in initProducts) {
      products.add({
        "id": product.produkId,
        "nama_produk": product.namaProduk,
        "image_url": product.imageUrl,
        "harga": product.harga,
        "jumlah": product.jumlah,
        "total_harga": (product?.harga ?? 0) * (product?.jumlah ?? 0),
      });
    }

    return products;
  }

  Future<TransactionModel> retrieveTransaction({required String token, required int customerId,})async{
    var url = Uri.parse("${baseURL}transaksi?customer_id=$customerId"); // Ini masih bisa ditambahkan banyak hal
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("transactionModel: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      TransactionModel transactionModel = TransactionModel.fromJson(data);

      return transactionModel;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

}
