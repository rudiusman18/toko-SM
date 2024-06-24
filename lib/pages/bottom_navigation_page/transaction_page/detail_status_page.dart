import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/detail_status_model.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/theme/theme.dart';

// ignore: must_be_immutable
class DetailStatusPage extends StatefulWidget {
  String invoice = "";
  DetailStatusPage({super.key, required this.invoice});

  @override
  State<DetailStatusPage> createState() => _DetailStatusPageState();
}

class _DetailStatusPageState extends State<DetailStatusPage> {
  DetailStatusModel detailStatusModel = DetailStatusModel();

  @override
  void initState() {
    _initGetDetailStatus();
    super.initState();
  }

  _initGetDetailStatus() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    TransaksiProvider transaksiProvider =
        Provider.of<TransaksiProvider>(context, listen: false);

    if (await transaksiProvider.getDetailStatus(
        token: loginProvider.loginModel.token ?? "", invoice: widget.invoice)) {
      setState(() {
        detailStatusModel = transaksiProvider.detailStatusModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text(
          "Detail Status",
          style: poppins.copyWith(
            fontWeight: bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            children: [
              OrderTrackerZen(
                background_color: Colors.grey,
                success_color: backgroundColor1,
                tracker_data: [
                  for (var i = 0;
                      i < (detailStatusModel.data?.length ?? 0);
                      i++)
                    TrackerData(
                      title: "${detailStatusModel.data?[i].status}",
                      date:
                          "${detailStatusModel.data?[i].date} - ${detailStatusModel.data?[i].time}",
                      tracker_details: [
                        TrackerDetails(
                          title: "${detailStatusModel.data?[i].deskripsi}",
                          datetime: "",
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
