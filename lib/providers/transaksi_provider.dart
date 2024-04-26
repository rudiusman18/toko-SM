
import 'package:flutter/cupertino.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/services/transaksi_service.dart';

class TransaksiProvider with ChangeNotifier{

  Future<bool> postTransaksi({required String token, required int pelangganId, required int cabangId, required int pengirimanId, required int kurirId, required String namaKurir, required int totalHarga, required int totalOngkosKirim, required int totalBelanja, required String metodePembayaran, required String namaPenerima, required String alamatPenerima, required String banktransfer, required String noRekeningTransfer, required List<DataKeranjang> product})async{
    try{
      await TransaksiService().sendTransaksi(token: token, pelangganId: pelangganId, cabangId: cabangId, pengirimanId: pengirimanId, kurirId: kurirId, namaKurir: namaKurir, totalHarga: totalHarga, totalOngkosKirim: totalOngkosKirim, totalBelanja: totalBelanja, metodePembayaran: metodePembayaran, namaPenerima: namaPenerima, alamatPenerima: alamatPenerima, banktransfer: banktransfer, noRekeningTransfer: noRekeningTransfer, product: product);
      return true;
    }catch(e){
      return false;
    }
  }
}