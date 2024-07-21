// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/transaction_page/detail_status_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/transaction_page/payment_manual_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/providers/ulasan_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:tokoSM/utils/alert_dialog.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DetailTransactionPage extends StatefulWidget {
  Data transactionDetailItem = Data();
  DetailTransactionPage({super.key, required this.transactionDetailItem});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  TextEditingController ulasanTextField = TextEditingController();
  TextEditingController bankPengirimTextField = TextEditingController(text: "");
  TextEditingController noRekeningPengirimTextField =
      TextEditingController(text: "");
  TextEditingController namaPengirimTextField = TextEditingController(text: "");

  FocusNode bankPengirimFocusNode = FocusNode();
  FocusNode noRekeningFocusNode = FocusNode();
  FocusNode namaPengirimFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    UlasanProvider ulasanProvider = Provider.of<UlasanProvider>(context);
    TransaksiProvider transaksiProvider =
        Provider.of<TransaksiProvider>(context);

    var starRating = 0.0;

    // ignore: no_leading_underscores_for_local_identifiers
    _bottomSheetKonfirmasiPembayaran() {
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.grey,
                    height: 2,
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 10),
                  child: Text(
                    "Konfirmasi Pembayaran",
                    style: poppins.copyWith(
                      fontWeight: bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: ListView(
                      children: [
                        // NOTE: Bank Pengirim
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Bank Pengirim",
                          style: poppins.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: bankPengirimFocusNode.hasFocus
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "nama bank pengirim",
                              hintStyle: poppins,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(0),
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 23, maxHeight: 20),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.account_balance,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            controller: bankPengirimTextField,
                            focusNode: bankPengirimFocusNode,
                            onTap: () {
                              setState(() {
                                noRekeningFocusNode.canRequestFocus = false;
                                namaPengirimFocusNode.canRequestFocus = false;
                                bankPengirimFocusNode.canRequestFocus = true;
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                bankPengirimFocusNode.canRequestFocus = false;
                              });
                            },
                          ),
                        ),

                        // NOTE: No Rekening Pengirim
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No Rekening Pengirim",
                          style: poppins.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: noRekeningFocusNode.hasFocus
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "nomor rekening pengirim",
                              hintStyle: poppins,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(0),
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 23, maxHeight: 20),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.import_contacts,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            controller: noRekeningPengirimTextField,
                            focusNode: noRekeningFocusNode,
                            onTap: () {
                              setState(() {
                                bankPengirimFocusNode.canRequestFocus = false;
                                namaPengirimFocusNode.canRequestFocus = false;
                                noRekeningFocusNode.canRequestFocus = true;
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                noRekeningFocusNode.canRequestFocus = false;
                              });
                            },
                          ),
                        ),

                        // NOTE: Nama Pengirim
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "nama Pengirim",
                          style: poppins.copyWith(
                            fontWeight: semiBold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: namaPengirimFocusNode.hasFocus
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "nama pengirim",
                              hintStyle: poppins,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.all(0),
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 23, maxHeight: 20),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            controller: namaPengirimTextField,
                            focusNode: namaPengirimFocusNode,
                            onTap: () {
                              setState(() {
                                noRekeningFocusNode.canRequestFocus = false;
                                namaPengirimFocusNode.canRequestFocus = true;
                                bankPengirimFocusNode.canRequestFocus = false;
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                namaPengirimFocusNode.canRequestFocus = false;
                              });
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: backgroundColor3,
                            ),
                            onPressed: () async {
                              if (!await transaksiProvider
                                  .sendPaymentConfirmation(
                                      token:
                                          loginProvider.loginModel.token ?? "",
                                      noInvoice: widget.transactionDetailItem
                                              .noInvoice ??
                                          "",
                                      bankPengirim: bankPengirimTextField.text,
                                      noRekeningPengirim:
                                          noRekeningPengirimTextField.text,
                                      namaPengirim:
                                          namaPengirimTextField.text)) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "gagal Menyimpan Informasi Pengiriman",
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Simpan",
                              style: poppins.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

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
                // Text(
                //   "Lihat Invoice",
                //   style: poppins.copyWith(
                //     color: backgroundColor3,
                //     fontWeight: bold,
                //     fontSize: 12,
                //   ),
                // ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Rp${currencyFormatter.format(produk?.harga)}",
                              style: poppins.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          produk?.multisatuanUnit == null
                              ? Text(
                                  "${(produk?.jumlah ?? 0)} ${produk?.satuanProduk}",
                                  style: poppins.copyWith(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i = 0;
                                        i <
                                            (produk?.jumlahMultisatuan
                                                    ?.length ??
                                                0);
                                        i++) ...{
                                      (produk?.jumlahMultisatuan?[i] ?? 0) == 0
                                          ? const SizedBox()
                                          : Text(
                                              "${(produk?.jumlahMultisatuan?[i] ?? 0)} ${produk?.multisatuanUnit?[i]}",
                                              style: poppins.copyWith(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            )
                                    }
                                  ],
                                ),
                        ],
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
                if (widget.transactionDetailItem.status == 4) ...{
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child:
                                showUlasanProduct(product: produk ?? Produk()),
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
                },
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
                    "Cabang ${widget.transactionDetailItem.namaCabang}", // (perlu diganti namanya)
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
      print("object data ${widget.transactionDetailItem.pembatalan}");
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
                    "${widget.transactionDetailItem.metodePembayaran}",
                    style: poppins.copyWith(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child: PaymentManualPage(
                        transactionDetailItem: widget.transactionDetailItem,
                      ),
                      type: PageTransitionType.bottomToTop,
                    ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.info,
                    color: backgroundColor3,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    "Cara Pembayaran",
                    style: poppins.copyWith(
                      fontSize: 12,
                      color: backgroundColor3,
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
          ),
          if ((widget.transactionDetailItem.status ?? 0) != 4 &&
              (widget.transactionDetailItem.status ?? 0) != 5 &&
              (widget.transactionDetailItem.status ?? 0) != 1 &&
              (widget.transactionDetailItem.status ?? 0) != 2 &&
              widget.transactionDetailItem.pembatalan != 1) ...{
            if (widget.transactionDetailItem.bankTransfer?.toLowerCase() !=
                    "cod" ||
                widget.transactionDetailItem.status != 0)
              Container(
                margin: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: (widget.transactionDetailItem.bankTransfer
                                  ?.toLowerCase() ==
                              "cod" ||
                          widget.transactionDetailItem.status == 0)
                      ? 5
                      : 15,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.transactionDetailItem.status == 0) {
                      _bottomSheetKonfirmasiPembayaran();
                    } else {
                      showAlertDialog(
                          context: context,
                          message:
                              "Anda yakin ingin mengubah status menjadi selesai?",
                          onCancelPressed: () => Navigator.pop(context),
                          onConfirmPressed: () async {
                            if (await transaksiProvider.postStatustransaksi(
                              token: loginProvider.loginModel.token ?? "",
                              noInvoice:
                                  widget.transactionDetailItem.noInvoice ?? "",
                              status: 4,
                            )) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor3,
                  ),
                  child: Text(
                    (widget.transactionDetailItem.status == 0)
                        ? "Konfirmasi Pembayaran"
                        : "Selesai",
                  ),
                ),
              ),
            if (widget.transactionDetailItem.status == 0)
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 15,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showAlertDialog(
                        context: context,
                        message: "Anda yakin ingin membatalkan pesanan?",
                        onCancelPressed: () => Navigator.pop(context),
                        onConfirmPressed: () async {
                          if (await transaksiProvider.postStatustransaksi(
                            token: loginProvider.loginModel.token ?? "",
                            noInvoice:
                                widget.transactionDetailItem.noInvoice ?? "",
                            status: 5,
                          )) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Batalkan",
                  ),
                ),
              ),
          },
        ],
      ),
    );
  }
}
