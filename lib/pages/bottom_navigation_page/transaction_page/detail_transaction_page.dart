// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/theme/theme.dart';

class DetailTransactionPage extends StatelessWidget {
  Data transactionDetailItem = Data();
  DetailTransactionPage({super.key, required this.transactionDetailItem});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            // NOTE: Status Pembayaran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${transactionDetailItem.keteranganStatus}"),
                Text("Lihat Detail"),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
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
                Text("${transactionDetailItem.noInvoice}"),
                Text("Lihat Invoice"),
              ],
            ),
            // NOTE: Tanggal Pembelian
            Row(
              children: [
                Text("Tanggal Pembelian"),
                Text("${transactionDetailItem.produk?.first.createdAt}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
