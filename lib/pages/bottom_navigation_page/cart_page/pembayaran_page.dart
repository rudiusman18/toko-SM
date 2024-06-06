import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/pembayaran_model.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/metode_pembayaran_provider.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class PembayaranPage extends StatefulWidget {
  final String cabangId;
  final int pelangganId;
  final int pengirimanId;
  final int kurirId;
  final String namaKurir;
  final int totalharga;
  final int totalOngkosKirim;
  final String namaPenerima;
  final String alamatPenerima;
  final List<DataKeranjang> product;

  final String totaltagihan;

  const PembayaranPage(
      {super.key,
      required this.cabangId,
      required this.totaltagihan,
      required this.pelangganId,
      required this.pengirimanId,
      required this.kurirId,
      required this.namaKurir,
      required this.totalharga,
      required this.totalOngkosKirim,
      required this.namaPenerima,
      required this.alamatPenerima,
      required this.product});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  PembayaranModel metodePembayaranModel = PembayaranModel();
  PembayaranModel pembayaranTerpilih = PembayaranModel();
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  List<bool> isChecked = [];

  _handleTapbayar() async {
    print(
        "data yang harus dibayarkan adalah: ${widget.totalharga}, ${widget.totalOngkosKirim}, ${widget.totaltagihan}");
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    TransaksiProvider transaksiProvider =
        Provider.of<TransaksiProvider>(context, listen: false);
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);
    if (pembayaranTerpilih.data?.isEmpty ?? true) {
      print("isi datany adalah ${widget.product}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Bank tujuan belum dipilih",
          style: poppins,
        ),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
    } else {
      if (await transaksiProvider.postTransaksi(
          token: loginProvider.loginModel.token ?? "",
          namaPelanggan: loginProvider.loginModel.data?.namaPelanggan ?? "",
          pelangganId: widget.pelangganId,
          cabangId: int.parse(widget.cabangId),
          pengirimanId: widget.pengirimanId,
          kurirId: widget.kurirId,
          namaKurir: widget.namaKurir,
          totalHarga: widget.totalharga,
          totalOngkosKirim: widget.totalOngkosKirim,
          totalBelanja: int.parse(widget.totaltagihan),
          metodePembayaran: "transfer",
          namaPenerima: widget.namaPenerima,
          alamatPenerima: widget.alamatPenerima,
          banktransfer: pembayaranTerpilih.data?.first.namaBank ?? "",
          noRekeningTransfer: pembayaranTerpilih.data?.first.noRekening ?? "",
          product: widget.product)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: backgroundColor1,
          content: Text(
            "Berhasil Melakukan Transaksi",
            style: poppins,
          ),
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            pageProvider.currentIndex = 3;
          });
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const MainPage(),
                  type: PageTransitionType.leftToRight),
              (route) => false);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Gagal mengirimkan data transaksi",
            style: poppins,
          ),
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initPilihMetodePembayaran();
  }

  _initPilihMetodePembayaran() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    MetodePembayaranProvider metodePembayaranProvider =
        Provider.of<MetodePembayaranProvider>(context, listen: false);
    if (await metodePembayaranProvider.getMetodePembayaran(
        token: loginProvider.loginModel.token ?? "",
        cabangId: widget.cabangId)) {
      setState(() {
        metodePembayaranModel = metodePembayaranProvider.metodePembayaranModel;
        for (var i = 0; i < (metodePembayaranModel.data?.length ?? 0); i++) {
          isChecked.add(false);
        }
      });
    }
  }

  Widget pembayaranItem({required int index}) {
    var metodePembayaran = metodePembayaranModel.data?[index];
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = isChecked.map((e) => e = false).toList();
          isChecked[index] = !isChecked[index];
          pembayaranTerpilih =
              PembayaranModel.fromJson(metodePembayaranModel.toJson());
          if (isChecked[index] == true) {
            pembayaranTerpilih.data?.clear();
            pembayaranTerpilih.data?.add(metodePembayaranModel.data![index]);
            print(
                "bank yang dipilih adalah ${pembayaranTerpilih.data?.first.namaBank}");
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  activeColor: backgroundColor3,
                  value: isChecked[index],
                  onChanged: (_) {},
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    "${metodePembayaran?.logoBank}",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${metodePembayaran?.namaBank}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "${metodePembayaran?.noRekening}",
                      style: poppins.copyWith(
                        fontWeight: regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pilih Metode Pembayaran",
          style: poppins,
        ),
        backgroundColor: backgroundColor3,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (var i = 0;
                    i < (metodePembayaranModel.data?.length ?? 0);
                    i++)
                  pembayaranItem(index: i)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(
              20,
            ),
            color: backgroundColor3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Tagihan: ",
                        style: poppins.copyWith(
                          color: Colors.white,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "Rp ${currencyFormatter.format(double.parse(widget.totaltagihan))}",
                        style: poppins.copyWith(
                          color: Colors.white,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      )),
                  onPressed: _handleTapbayar,
                  icon: const Icon(Icons.check_circle),
                  label: Text(
                    "Bayar",
                    style: poppins,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
