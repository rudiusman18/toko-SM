import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/detail_status_model.dart';

import '../models/transaction_model.dart';

class TransaksiService {
  var client = HttpClient();
  var baseURL = "http://103.127.132.116/api/v1/";

  Future<Map<String, dynamic>> sendTransaksi({
    required String token,
    required String namaPelanggan,
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
      "nama_pelanggan": namaPelanggan,
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

  List<Map<String, dynamic>> generateProducts(
      {required List<DataKeranjang> initProducts}) {
    // Create a list to hold the dynamic products
    List<Map<String, dynamic>> products = [];

    // Convert Product objects to Map and add them to the list
    for (DataKeranjang product in initProducts) {
      print("golongan product nya adalah: ${product.golonganProduk}");
      products.add({
        "id": product.produkId,
        "nama_produk": product.namaProduk,
        "golongan_produk": product.golonganProduk,
        "image_url": product.imageUrl,
        "harga": product.harga,
        "jumlah": product.jumlah,
        "kategori": product.kategori,
        "kategori_slug": product.kategoriSlug,
        "jumlah_multisatuan": product.jumlahMultisatuan,
        "multisatuan_jumlah": product.multisatuanJumlah,
        "multisatuan_unit": product.multisatuanUnit,
        "total_harga": (product.harga ?? 0) * (product.jumlah ?? 0),
      });
    }

    return products;
  }

  Future<TransactionModel> retrieveTransaction({
    required String token,
    required int customerId,
    String status = "",
    String tanggalAwal = "",
    String tanggalAkhir = "",
  }) async {
    var url = Uri.parse(
        "${baseURL}transaksi?customer_id=$customerId&status=$status&tanggal_awal=$tanggalAwal&tanggal_akhir=$tanggalAkhir"); // Ini masih bisa ditambahkan banyak hal

    print(
        "url yang diakses adalah:${baseURL}transaksi?customer_id=$customerId&status=$status&tanggal_awal=$tanggalAwal&tanggal_akhir=$tanggalAkhir");

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

  Future<DetailStatusModel> retrieveDetailStatus({
    required String token,
    required String invoice,
  }) async {
    var url = Uri.parse("${baseURL}transaksi/status/$invoice");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("detailStatusModel: ${response.body}");

// **success melakukan get cart
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      DetailStatusModel transactionModel = DetailStatusModel.fromJson(data);

      return transactionModel;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }

  Future<Map<String, dynamic>> postStatusTransaksi({
    required String token,
    required noInvoice,
    required int status,
  }) async {
    var url = Uri.parse("${baseURL}transaksi/status");
    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map data = {
      "no_invoice": noInvoice,
      "status": status,
    };

    var body = jsonEncode(data);

    var response = await http.post(
      url,
      headers: header,
      body: body,
    );
    // ignore: avoid_print
    print("status transaksi: ${response.body}");

// **success melakukan post status transaksi
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("${jsonDecode(response.body)['message']}");
    }
  }
}
