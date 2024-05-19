import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page/alamat_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page/pembayaran_page.dart';
import 'package:tokoSM/providers/alamat_provider.dart';
import 'package:tokoSM/providers/kurir_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class Deliverypage extends StatefulWidget {
  final String namaCabang;
  final int indexCabang;
  final CartModel product;
  const Deliverypage(
      {super.key,
      required this.namaCabang,
      required this.indexCabang,
      required this.product});

  @override
  State<Deliverypage> createState() => _DeliverypageState();
}

class _DeliverypageState extends State<Deliverypage> {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  String kurirDigunakan = "";
  int kurirId = 0;

  _loading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      height: MediaQuery.sizeOf(context).width * 0.3,
                      child: CircularProgressIndicator(
                        color: backgroundColor3,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Loading...", style: poppins),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _initAlamatData();
  }

  _initAlamatData() async {
    AlamatProvider alamatProvider =
        Provider.of<AlamatProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    if (await alamatProvider.getAlamat(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Gagal mendapatkan data alamat",
          style: poppins,
        ),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalHargaRingkasan = 0.0;
    KurirProvider kurirProvider = Provider.of<KurirProvider>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    AlamatProvider alamatProvider = Provider.of<AlamatProvider>(context);

    Widget alamatPengiriman() {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                child: const AlamatPage(),
                type: PageTransitionType.rightToLeft,
              )).then((value) {
            setState(() {});
          });
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.all(
            20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alamat Pengiriman",
                      style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: backgroundColor3,
                        ),
                        Text(
                          alamatProvider.deliveryAlamat.data?.isEmpty ?? true
                              ? "${alamatProvider.alamatModel.data?.first.namaAlamat} - ${alamatProvider.alamatModel.data?.first.namaPenerima}"
                              : "${alamatProvider.deliveryAlamat.data?.first.namaAlamat} - ${alamatProvider.deliveryAlamat.data?.first.namaPenerima}",
                          style: poppins.copyWith(
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      alamatProvider.deliveryAlamat.data?.isEmpty ?? true
                          ? "${alamatProvider.alamatModel.data?.first.alamatLengkap}, ${alamatProvider.alamatModel.data?.first.kelurahan?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.kecamatan?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.kabkota?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.provinsi?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.kodepos?.toLowerCase()}"
                          : "${alamatProvider.deliveryAlamat.data?.first.alamatLengkap}, ${alamatProvider.deliveryAlamat.data?.first.kelurahan?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.kecamatan?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.kabkota?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.provinsi?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.kodepos?.toLowerCase()}",
                      style: poppins.copyWith(
                        fontWeight: light,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    Widget productItem({required int index}) {
      var product = widget.product.data?[widget.indexCabang].data?[index];
      var totalharga = (product?.jumlah ?? 0) *
          ((product?.diskon != null)
              ? (product?.harga ?? 0)
              : (product?.hargaDiskon ?? 0));
      totalHargaRingkasan += totalharga;
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.red,
              child: Image.network(
                "http://103.127.132.116/uploads/images/${product?.imageUrl}",
                width: 80,
                height: 80,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${product?.namaProduk}",
                      style: poppins,
                    ),
                    Text(
                      "${product?.jumlah} x Rp ${currencyFormatter.format(product?.diskon != null ? product?.harga : product?.hargaDiskon)}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "Total: Rp ${currencyFormatter.format(totalharga)}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "\"${product?.catatan}\"",
                      style: poppins.copyWith(
                        fontSize: 10,
                        fontWeight: light,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget listKurir({required int index}) {
      return InkWell(
        onTap: () {
          setState(() {
            kurirDigunakan =
                "${kurirProvider.kurirModel.data?[index].namaKurir}";
            kurirId = kurirProvider.kurirModel.data?[index].id ?? 0;
            Navigator.pop(context);
          });
        },
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${kurirProvider.kurirModel.data?[index].namaKurir} (Rp${currencyFormatter.format(15000)})",
                style: poppins.copyWith(
                  fontWeight: bold,
                ),
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      );
    }

    Widget kurir() {
      return InkWell(
        onTap: () {
          setState(() {
            kurirProvider.kurirModel.data = null;
            print(
                "apakah saat ini kurir model dalam keadaan koson: ${kurirProvider.kurirModel.data?.isEmpty ?? true}");
          });
          if (kurirProvider.kurirModel.data?.isEmpty ?? true) {
            Future.delayed(Duration.zero, () async {
              setState(() {
                _loading();
              });
              if (await kurirProvider.getKurir(
                  token: loginProvider.loginModel.token ?? "",
                  cabangId: "${widget.product.data?[widget.indexCabang].id}")) {
                // print("isi kurir adalah: ${kurirProvider.kurirModel.data?.first.namaKurir}");
                setState(() {
                  Navigator.pop(context);
                });
                // ignore: use_build_context_synchronously
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                      ),
                      height: 400,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Kurir",
                                style: poppins.copyWith(
                                  fontSize: 20,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            padding: const EdgeInsets.all(
                              20,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.storefront,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Dikirim dari cabang ${widget.namaCabang}",
                                  style: poppins,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child:
                                kurirProvider.kurirModel.data?.isEmpty ?? true
                                    ? Center(
                                        child: Text(
                                          "Tidak ada data kurir",
                                          style: poppins,
                                        ),
                                      )
                                    : ListView(
                                        children: [
                                          for (var i = 0;
                                              i <
                                                  (kurirProvider.kurirModel.data
                                                          ?.length ??
                                                      0);
                                              i++)
                                            listKurir(index: i)
                                        ],
                                      ),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                setState(() {
                  Navigator.pop(context);
                });
              }
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (kurirDigunakan == ""
                      ? "Pilih Kurir"
                      : "$kurirDigunakan (Rp ${currencyFormatter.format(15000)})"),
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    Widget ringkasanItem({required String title, required String value}) {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: poppins.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
                child: Text(
              value,
              style: poppins.copyWith(
                fontSize: 12,
                fontWeight:
                    title.toLowerCase() == "total belanja" ? bold : regular,
              ),
              textAlign: TextAlign.end,
            )),
          ],
        ),
      );
    }

    Widget ringkasan() {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ringkasan",
              style: poppins.copyWith(
                fontWeight: bold,
              ),
            ),
            ringkasanItem(
              title: "Total harga (jumlah barang)",
              value: "Rp ${currencyFormatter.format(totalHargaRingkasan)}",
            ),
            ringkasanItem(
              title: "Total ongkos kirim",
              value: kurirDigunakan == ""
                  ? "-"
                  : "Rp ${currencyFormatter.format(15000)}",
            ),
            ringkasanItem(
              title: "Total belanja",
              value:
                  "Rp ${currencyFormatter.format(totalHargaRingkasan + (kurirDigunakan == "" ? 0 : 15000))}",
            ),
          ],
        ),
      );
    }

    Widget product() {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.location_city,
                  color: backgroundColor2,
                ),
                Expanded(
                  child: Text(
                    "Cabang ${widget.namaCabang}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: poppins.copyWith(
                      color: backgroundColor2,
                      fontWeight: medium,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            for (var i = 0;
                i <
                    (widget.product.data?[widget.indexCabang].data?.length ??
                        0);
                i++)
              productItem(index: i),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text(
          "Pengiriman",
          style: poppins.copyWith(
            fontWeight: bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          alamatPengiriman(),
          product(),
          kurir(),
          ringkasan(),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (kurirDigunakan == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Anda belum memilih kurir",
                      style: poppins,
                    ),
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ));
                } else {
                  print(
                      "total tagihannya adalah:${totalHargaRingkasan + (kurirDigunakan == "" ? 0 : 15000)}");
                  Navigator.push(
                      context,
                      PageTransition(
                        child: PembayaranPage(
                          cabangId:
                              "${widget.product.data?[widget.indexCabang].id}",
                          totaltagihan:
                              "${totalHargaRingkasan.toInt() + (kurirDigunakan == "" ? 0 : 15000)}",
                          alamatPenerima: alamatProvider
                                      .deliveryAlamat.data?.isEmpty ??
                                  true
                              ? "${alamatProvider.alamatModel.data?.first.alamatLengkap}, ${alamatProvider.alamatModel.data?.first.kelurahan?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.kecamatan?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.kabkota?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.provinsi?.toLowerCase()}, ${alamatProvider.alamatModel.data?.first.kodepos?.toLowerCase()}"
                              : "${alamatProvider.deliveryAlamat.data?.first.alamatLengkap}, ${alamatProvider.deliveryAlamat.data?.first.kelurahan?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.kecamatan?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.kabkota?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.provinsi?.toLowerCase()}, ${alamatProvider.deliveryAlamat.data?.first.kodepos?.toLowerCase()}",
                          kurirId: kurirId,
                          namaKurir: kurirDigunakan,
                          namaPenerima:
                              "${alamatProvider.alamatModel.data?.first.namaPenerima}",
                          pelangganId: loginProvider.loginModel.data?.id ?? 0,
                          pengirimanId: alamatProvider
                                      .deliveryAlamat.data?.isEmpty ??
                                  true
                              ? alamatProvider.alamatModel.data?.first.id ?? 0
                              : alamatProvider.deliveryAlamat.data?.first.id ??
                                  0,
                          product:
                              widget.product.data![widget.indexCabang].data!,
                          totalharga: totalHargaRingkasan.toInt(),
                          totalOngkosKirim: 15000,
                        ),
                        type: PageTransitionType.rightToLeft,
                      ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor3,
              ),
              child: Text(
                "Pilih Pembayaran",
                style: poppins,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
