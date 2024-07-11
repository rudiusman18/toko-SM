// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/transaction_page/detail_transaction_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  TransactionModel transactionModel = TransactionModel();
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  bool isLoading = false;

  // Initial Selected Value
  String dropdownvalue = 'Semua Status';

  // List of items in our dropdown menu
  var items = [
    'Semua Status',
    'Belum Dibayar',
    'Diproses',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void initState() {
    _initTransaction();
    super.initState();
  }

  _initTransaction({
    String status = "",
    String tanggalAwal = "",
    String tanggalAkhir = "",
  }) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    TransaksiProvider transactionProvider =
        Provider.of<TransaksiProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    if (await transactionProvider.getTransaction(
      token: loginProvider.loginModel.token ?? "",
      customerId: loginProvider.loginModel.data?.id ?? 0,
      status: status,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    )) {
      setState(() {
        transactionModel = transactionProvider.transactionModel;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Gagal mendapatkan riwayat transaksi",
          style: poppins,
        ),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    TransaksiProvider transaksiProvider =
        Provider.of<TransaksiProvider>(context);

    void showAlertDialog(BuildContext context, String noInvoice) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "Warning!",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                    fontWeight: semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: backgroundColor1,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            content: Text(
              "Anda yakin untuk mengubah status menjadi selesai?",
              style: poppins.copyWith(color: backgroundColor1),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Batal",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: backgroundColor1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (await transaksiProvider.postStatustransaksi(
                    token: loginProvider.loginModel.token ?? "",
                    noInvoice: noInvoice,
                    status: 4,
                  )) {
                    _initTransaction();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Lanjutkan",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: backgroundColor1,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    Widget transactionItem({required int index}) {
      var transaction = transactionModel.data?[index];
      String timestamp = "${transaction?.produk?.first.createdAt}";
      DateTime dateTime = DateTime.parse(timestamp);
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: DetailTransactionPage(
                transactionDetailItem: transaction!,
              ),
              type: PageTransitionType.rightToLeft,
            ),
          ).then((_) {
            _initTransaction();
          });
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          padding: const EdgeInsets.all(
            10,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: backgroundColor3,
                    size: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Belanja",
                        style: poppins.copyWith(
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        "$formattedDate",
                        style: poppins.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    color: "${transaction?.keteranganStatus}".toLowerCase() ==
                            "belum dibayar"
                        ? Colors.orange.withOpacity(0.2)
                        : "${transaction?.keteranganStatus}".toLowerCase() ==
                                "dibatalkan"
                            ? Colors.red.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "${transaction?.keteranganStatus}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                        color:
                            "${transaction?.keteranganStatus}".toLowerCase() ==
                                    "belum dibayar"
                                ? Colors.orange
                                : "${transaction?.keteranganStatus}"
                                            .toLowerCase() ==
                                        "dibatalkan"
                                    ? Colors.red
                                    : Colors.green,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Image.network(
                      "http://103.127.132.116/uploads/images/${transaction?.produk?.first.imageUrl}",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${transaction?.produk?.first.namaProduk}",
                          style: poppins.copyWith(
                            fontWeight: bold,
                          ),
                        ),
                        Text(
                          "${transaction?.produk?.first.jumlah} Barang",
                          style: poppins.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        (transaction?.produk?.length ?? 1) - 1 == 0
                            ? const SizedBox()
                            : Text(
                                "+ ${(transaction?.produk?.length ?? 1) - 1} Barang Lainnya",
                                style: poppins.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total belanja",
                        style: poppins.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Rp ${currencyFormatter.format(transaction?.totalBelanja?.toInt())}",
                        style: poppins.copyWith(
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                  (transaction?.status == 4)
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: backgroundColor3,
                          ),
                          child: const Text(
                            "Beli Lagi",
                          ),
                        )
                      : (transaction?.status == 3)
                          ? ElevatedButton(
                              onPressed: () {
                                showAlertDialog(
                                    context, transaction?.noInvoice ?? "");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: backgroundColor3,
                              ),
                              child: const Text(
                                "Selesai",
                              ),
                            )
                          : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget emptyTransaction() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/bag.png",
            width: 150,
            height: 150,
          ),
          Text(
            "OOPS...!",
            style: poppins.copyWith(
              fontSize: 50,
              fontWeight: semiBold,
              color: backgroundColor3,
            ),
          ),
          Text(
            "Anda tidak memiliki transaksi apapun saat ini",
            style: poppins.copyWith(
              fontSize: 15,
              color: backgroundColor3,
              fontWeight: medium,
            ),
          ),
        ],
      );
    }

    Widget filter() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              DropdownButton(
                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    int index = items.indexOf(newValue);
                    print("indexnya adalah ${index - 1}");
                    _initTransaction(
                        status: "${index - 1 < 0 ? "" : index - 1}");
                  });
                },
              ),
              Container(
                decoration: BoxDecoration(boxShadow: []),
              )
              // Text(
              //   "Status",
              // ),
              // Text(
              //   "Status",
              // ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaksi",
          style: poppins.copyWith(
            color: Colors.white,
            fontWeight: semiBold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor3,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: backgroundColor1,
                  ),
                ),
              )
            : Container(
                color: Colors.white,
                width: MediaQuery.sizeOf(context).width,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    filter(),
                    (transactionModel.data?.length ?? 0) == 0
                        ? emptyTransaction()
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    for (var i = 0;
                        i < (transactionModel.data?.length ?? 0);
                        i++)
                      transactionItem(index: i)
                  ],
                ),
              ),
      ),
    );
  }
}
