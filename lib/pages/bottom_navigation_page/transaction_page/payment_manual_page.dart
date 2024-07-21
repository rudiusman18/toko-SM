import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/theme/theme.dart';

// ignore: must_be_immutable
class PaymentManualPage extends StatefulWidget {
  Data transactionDetailItem = Data();
  PaymentManualPage({
    super.key,
    required this.transactionDetailItem,
  });

  @override
  State<PaymentManualPage> createState() => _PaymentManualPageState();
}

class _PaymentManualPageState extends State<PaymentManualPage> {
  Map<String, dynamic> paymentManualMap = {};

  @override
  void initState() {
    _getPaymentManual();
    super.initState();
  }

  _getPaymentManual() async {
    TransaksiProvider transactionProvider =
        Provider.of<TransaksiProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    if (await transactionProvider.retrievePaymentManual(
        token: loginProvider.loginModel.token ?? "",
        cabangId: "${widget.transactionDetailItem.cabangId}",
        kode: widget.transactionDetailItem.kodePembayaran ?? "")) {
      setState(() {
        paymentManualMap = transactionProvider.paymentManual;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text(
          "Tata Cara Pembayaran",
          style: poppins.copyWith(
            fontWeight: bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: HtmlWidget(
          '''
          ${paymentManualMap['data']}
      ''',
          textStyle: poppins,
        ),
      ),
    );
  }
}
