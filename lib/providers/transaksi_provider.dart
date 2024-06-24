import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/detail_status_model.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/services/transaksi_service.dart';

class TransaksiProvider with ChangeNotifier {
  Future<bool> postTransaksi(
      {required String token,
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
      required List<DataKeranjang> product}) async {
    try {
      await TransaksiService().sendTransaksi(
          token: token,
          namaPelanggan: namaPelanggan,
          pelangganId: pelangganId,
          cabangId: cabangId,
          pengirimanId: pengirimanId,
          kurirId: kurirId,
          namaKurir: namaKurir,
          totalHarga: totalHarga,
          totalOngkosKirim: totalOngkosKirim,
          totalBelanja: totalBelanja,
          metodePembayaran: metodePembayaran,
          namaPenerima: namaPenerima,
          alamatPenerima: alamatPenerima,
          banktransfer: banktransfer,
          noRekeningTransfer: noRekeningTransfer,
          product: product);
      return true;
    } catch (e) {
      return false;
    }
  }

  TransactionModel _transactionModel = TransactionModel();
  TransactionModel get transactionModel => _transactionModel;
  set transactionModel(TransactionModel transactionModel) {
    _transactionModel = transactionModel;
    notifyListeners();
  }

  Future<bool> getTransaction({
    required String token,
    required int customerId,
    String status = "",
    String tanggalAwal = "",
    String tanggalAkhir = "",
  }) async {
    // Ini nanti masih banyak yang bisa ditambahkan
    try {
      TransactionModel transactionModel =
          await TransaksiService().retrieveTransaction(
        token: token,
        customerId: customerId,
        status: status,
        tanggalAwal: tanggalAwal,
        tanggalAkhir: tanggalAkhir,
      );
      _transactionModel = transactionModel;
      return true;
    } catch (e) {
      return false;
    }
  }

  DetailStatusModel _detailStatusModel = DetailStatusModel();
  DetailStatusModel get detailStatusModel => _detailStatusModel;
  set detailStatusModel(DetailStatusModel detailStatusModel) {
    _detailStatusModel = detailStatusModel;
    notifyListeners();
  }

  Future<bool> getDetailStatus(
      {required String token, required String invoice}) async {
    try {
      DetailStatusModel detailStatusModel = await TransaksiService()
          .retrieveDetailStatus(token: token, invoice: invoice);
      _detailStatusModel = detailStatusModel;
      return true;
    } catch (e) {
      return false;
    }
  }
}
