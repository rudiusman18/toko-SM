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
                  "${transactionDetailItem.noInvoice} aiosdjioajsdioajsdioajsdiojadiojaiosdjaiodsj",
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
            Text(
              "Detail Produk",
              style: poppins.copyWith(
                fontWeight: bold,
              ),
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
        ],
      ),
    );
  }
}
