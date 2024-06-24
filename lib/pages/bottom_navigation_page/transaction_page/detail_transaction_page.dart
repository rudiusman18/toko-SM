// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/transaction_page/detail_status_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/ulasan_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class DetailTransactionPage extends StatefulWidget {
  Data transactionDetailItem = Data();
  DetailTransactionPage({super.key, required this.transactionDetailItem});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  TextEditingController ulasanTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    UlasanProvider ulasanProvider = Provider.of<UlasanProvider>(context);

    var starRating = 0.0;

    Widget statusView() {
      String timestamp =
          "${widget.transactionDetailItem.produk?.first.createdAt}";
      DateTime dateTime = DateTime.parse(timestamp);
      String formattedDate = DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);

      return Container(
        padding: const EdgeInsets.all(
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 8), // Shadow position
            ),
          ],
        ),
        child: Column(
          children: [
            // NOTE: Status Pembayaran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.transactionDetailItem.keteranganStatus}",
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: DetailStatusPage(
                            invoice:
                                widget.transactionDetailItem.noInvoice ?? "",
                          ),
                          type: PageTransitionType.rightToLeft,
                        ));
                  },
                  child: Text(
                    "Lihat Detail",
                    style: poppins.copyWith(
                      color: backgroundColor3,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            // NOTE: Invoice
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.transactionDetailItem.noInvoice}",
                  style: poppins.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Lihat Invoice",
                  style: poppins.copyWith(
                    color: backgroundColor3,
                    fontWeight: bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // NOTE: Tanggal Pembelian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tanggal Pembelian",
                  style: poppins.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "$formattedDate WIB",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget customtextFormField({
      required TextInputType keyboardType,
      required TextEditingController controller,
    }) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          textInputAction: TextInputAction.newline,
          maxLines: 4,
          style: poppins.copyWith(
            color: backgroundColor1,
          ),
          keyboardType: keyboardType,
          cursorColor: backgroundColor1,
          controller: controller,
          decoration: InputDecoration(
            hintText: "...",
            hintStyle: poppins.copyWith(
              color: backgroundColor1,
            ),
            prefixIconColor: Colors.grey,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget showUlasanProduct({
      required Produk product,
    }) {
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, stateSetter) {
          return Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ulasan Produk",
                    style: poppins.copyWith(
                      fontWeight: semiBold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              "http://103.127.132.116/uploads/images/${product.imageUrl}",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${product.namaProduk}",
                          style: poppins.copyWith(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RatingStars(
                    value: starRating,
                    onValueChanged: (v) {
                      stateSetter(() {
                        // value = v;
                        starRating = v;
                      });
                    },
                    starBuilder: (index, color) => Icon(
                      Icons.star,
                      color: color,
                      size: 30,
                    ),
                    starCount: 5,
                    starSize: 30,
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: medium,
                      fontStyle: FontStyle.normal,
                    ),
                    valueLabelRadius: 10,
                    maxValue: 5,
                    starSpacing: 2,
                    maxValueVisibility: true,
                    valueLabelVisibility: false,
                    animationDuration: const Duration(milliseconds: 1000),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: backgroundColor2,
                  ),
                  customtextFormField(
                    controller: ulasanTextField,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () async {
                        stateSetter(() {
                          isLoading = true;
                        });
                        await ulasanProvider.postUlasanProduct(
                          invoice: product.noInvoice ?? "",
                          namaProduk: product.namaProduk ?? "",
                          productId: product.id ?? 0,
                          token: loginProvider.loginModel.token ?? "",
                          rating: int.parse("${starRating.round()}"),
                          ulasan: ulasanTextField.text,
                        );
                        stateSetter(() {
                          isLoading = false;
                          Navigator.pop(context);
                        });
                      },
                      child: isLoading
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Simpan",
                              style: poppins,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget detailProductViewItem({required int index}) {
      var produk = widget.transactionDetailItem.produk?[index];
      return Container(
        padding: const EdgeInsets.all(
          10,
        ),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withAlpha(60),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 1,
              offset: const Offset(1, 4), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  "http://103.127.132.116/uploads/images/${produk?.imageUrl}",
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${produk?.namaProduk}",
                        style: poppins.copyWith(
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "${produk?.jumlah} x Rp${currencyFormatter.format(produk?.harga)}",
                        style: poppins.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total harga",
                      style: poppins.copyWith(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "Rp ${currencyFormatter.format(produk?.totalHarga?.toInt())}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    print("ditekan");

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: showUlasanProduct(product: produk ?? Produk()),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                      5,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor3,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Text(
                      "Beri Ulasan",
                      style: poppins.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(
                      5,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        border: Border.all(
                          color: backgroundColor3,
                          width: 1,
                        )),
                    child: Text(
                      "Beli Lagi",
                      style: poppins.copyWith(
                        color: backgroundColor3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget detailProductView() {
      return Container(
        padding: const EdgeInsets.all(
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 8), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail Produk",
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Cabang ${widget.transactionDetailItem.cabangId}", // (perlu diganti namanya)
                    style: poppins.copyWith(
                      fontWeight: bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (var i = 0;
                i < (widget.transactionDetailItem.produk?.length ?? 0);
                i++)
              detailProductViewItem(index: i),
          ],
        ),
      );
    }

    Widget infoPengirimanView() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 8), // Shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informasi Pengiriman",
              style: poppins.copyWith(
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // NOTE: Kurir
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kurir",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 105,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 10,
                  child: Text(
                    "${widget.transactionDetailItem.namaKurir}",
                    style: poppins.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // NOTE: NO Resi

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       "Nomor Resi",
            //       style: poppins.copyWith(
            //         fontSize: 12,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 63,
            //     ),
            //     Flexible(
            //       fit: FlexFit.tight,
            //       flex: 10,
            //       child: Text(
            //         "${transactionDetailItem.sId}",
            //         style: poppins.copyWith(
            //           fontSize: 12,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // NOTE: Alamat
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alamat",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 88,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.transactionDetailItem.namaPenerima}",
                        style: poppins.copyWith(
                          fontSize: 12,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "${widget.transactionDetailItem.alamatPenerima}",
                        style: poppins.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget infoPembayaranView() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 8), // Shadow position
            ),
          ],
        ),
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOTE: Metode Pembayaran
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Metode Pembayaran",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Text(
                    "${widget.transactionDetailItem.bankTransfer}",
                    style: poppins.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 1,
            ),
            // NOTE: Total harga
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Harga (${widget.transactionDetailItem.produk?.length} Barang)",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Text(
                    "Rp ${currencyFormatter.format(widget.transactionDetailItem.totalBelanja!.toInt() - 15000)}",
                    style: poppins.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // NOTE: Total Ongkos Kirim
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Ongkos Kirim",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Text(
                    "Rp ${currencyFormatter.format(15000)}",
                    style: poppins.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 1,
            ),
            // NOTE: Total Belanja
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Belanja",
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Text(
                    "Rp ${currencyFormatter.format(widget.transactionDetailItem.totalBelanja)}",
                    style: poppins.copyWith(
                      fontWeight: bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text(
          "Detail Transaksi",
          style: poppins.copyWith(
            fontWeight: bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          statusView(),
          const SizedBox(
            height: 5,
          ),
          detailProductView(),
          const SizedBox(
            height: 5,
          ),
          infoPengirimanView(),
          const SizedBox(
            height: 5,
          ),
          infoPembayaranView(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
