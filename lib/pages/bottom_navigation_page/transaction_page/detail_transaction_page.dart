// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/theme/theme.dart';

class DetailTransactionPage extends StatelessWidget {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  Data transactionDetailItem = Data();
  DetailTransactionPage({super.key, required this.transactionDetailItem});

  @override
  Widget build(BuildContext context) {
    Widget statusView() {
      String timestamp = "${transactionDetailItem.produk?.first.createdAt}";
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
                  "${transactionDetailItem.keteranganStatus}",
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
                ),
                Text(
                  "Lihat Detail",
                  style: poppins.copyWith(
                    color: backgroundColor3,
                    fontWeight: bold,
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
                  "${transactionDetailItem.noInvoice}",
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

    Widget detailPRoductViewItem({required int index}) {
      var produk = transactionDetailItem.produk?[index];
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
                  "https://tokosm.online/uploads/images/${produk?.imageUrl}",
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    "Cabang ${transactionDetailItem.cabangId} (perlu diganti namanya)",
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
                i < (transactionDetailItem.produk?.length ?? 0);
                i++)
              detailPRoductViewItem(index: i),
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
                    "${transactionDetailItem.namaKurir}",
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
                        "${transactionDetailItem.namaPenerima}",
                        style: poppins.copyWith(
                          fontSize: 12,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "${transactionDetailItem.alamatPenerima}",
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
                    "${transactionDetailItem.bankTransfer}",
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
                  "Total Harga (${transactionDetailItem.produk?.length} Barang)",
                  style: poppins.copyWith(
                    fontSize: 12,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Text(
                    "Rp ${currencyFormatter.format(transactionDetailItem.totalBelanja!.toInt() - 15000)}",
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
                    "Rp ${currencyFormatter.format(transactionDetailItem.totalBelanja)}",
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
