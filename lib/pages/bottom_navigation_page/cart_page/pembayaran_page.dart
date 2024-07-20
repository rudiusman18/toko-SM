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
  List<List<bool>> isChecked = [];
  int index = 0;
  int index2 = 0;

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
      print(
          "pembayaran terpilih: ${pembayaranTerpilih.data?[0].kategori ?? ""} dengan ${((pembayaranTerpilih.data?[0].kategori ?? "").toLowerCase() != "transfer bank") ? (pembayaranTerpilih.data?[0].child?[index2].nama ?? "") : ""}");
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
        metodePembayaran:
            pembayaranTerpilih.data?[0].child?[index2].metode ?? "",
        kodePembayaran: pembayaranTerpilih.data?[0].child?[index2].kode ?? "",
        namaPenerima: widget.namaPenerima,
        alamatPenerima: widget.alamatPenerima,
        banktransfer:
            ((pembayaranTerpilih.data?[0].kategori ?? "").toLowerCase() !=
                    "transfer bank")
                ? (pembayaranTerpilih.data?[0].child?[index2].nama ?? "")
                : "",
        noRekeningTransfer: "",
        product: widget.product,
      )) {
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
        List<bool> data = [];
        for (var i = 0; i < (metodePembayaranModel.data?.length ?? 0); i++) {
          data.clear();
          for (var j = 0;
              j < (metodePembayaranModel.data?[i].child?.length ?? 0);
              j++) {
            data.add(false);
          }
          isChecked.add(data);
        }
        print("jumlah ischecked adalah: $isChecked");
      });
    }
  }

  Widget pembayaranItem({required int index, required int index2}) {
    var metodePembayaran = metodePembayaranModel.data?[index];
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = isChecked.map((row) {
            return row.map((value) => value = false).toList();
          }).toList();
          isChecked[index][index2] = !isChecked[index][index2];
          pembayaranTerpilih =
              PembayaranModel.fromJson(metodePembayaranModel.toJson());
          if (isChecked[index][index2] == true) {
            pembayaranTerpilih.data?.clear();
            pembayaranTerpilih.data?.add(metodePembayaranModel.data![index]);
            // print(
            //     "bank yang dipilih adalah ${pembayaranTerpilih.data?.first.namaBank}");
          }
          this.index = index;
          this.index2 = index2;
          print("pembayaran terpilih: $index dengan $index2");
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
                  value: isChecked[index][index2],
                  onChanged: (_) {},
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    "${metodePembayaran?.child?[index2].image}",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${metodePembayaran?.child?[index2].nama}",
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
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
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Text(
                    "Pilih Metode Pembayaran",
                    style: poppins.copyWith(
                      fontWeight: bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                for (var i = 0;
                    i < (metodePembayaranModel.data?.length ?? 0);
                    i++) ...{
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Text(
                      "${metodePembayaranModel.data?[i].kategori}",
                    ),
                  ),
                  for (var index = 0;
                      index <
                          (metodePembayaranModel.data?[i].child?.length ?? 0);
                      index++)
                    pembayaranItem(index: i, index2: index)
                },
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
