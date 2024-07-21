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
      required String kodePembayaran,
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
          kodePembayaran: kodePembayaran,
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

  Future<bool> postStatustransaksi({
    required String token,
    required String noInvoice,
    required int status,
  }) async {
    try {
      await TransaksiService().postStatusTransaksi(
          token: token, noInvoice: noInvoice, status: status);
      return true;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> _paymentManual = {};
  Map<String, dynamic> get paymentManual => _paymentManual;
  set paymentManual(Map<String, dynamic> paymentManualResponse) {
    _paymentManual = paymentManualResponse;
    notifyListeners();
  }

  Future<bool> retrievePaymentManual({
    required String token,
    required String cabangId,
    required String kode,
  }) async {
    try {
      Map<String, dynamic> paymentManualResponse = await TransaksiService()
          .getPaymentManual(token: token, cabangId: cabangId, kode: kode);
      _paymentManual = paymentManualResponse;
      print("berhasil mendapatkan data manual payment");
      return true;
    } catch (e) {
      print("berhasil mendapatkan data manual payment dengan pesan error $e");
      return false;
    }
  }

  Future<bool> sendPaymentConfirmation({
    required String token,
    required String noInvoice,
    required String bankPengirim,
    required String noRekeningPengirim,
    required String namaPengirim,
  }) async {
    try {
      await TransaksiService().postPaymentConfirmation(
          token: token,
          noInvoice: noInvoice,
          bankPengirim: bankPengirim,
          norekeningPengirim: noRekeningPengirim,
          namaPengirim: namaPengirim);
      print("Konfirmasi Pembayaran berhasil dilakukan");
      return true;
    } catch (e) {
      print("konfirmasi pembayaran gagal dilakuakn dengan pesan $e");
      return false;
    }
  }
}
