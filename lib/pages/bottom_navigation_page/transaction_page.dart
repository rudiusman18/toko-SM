// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tokoSM/models/transaction_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/transaction_page/detail_transaction_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:tokoSM/utils/alert_dialog.dart';

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
  // String dropdownvalue = 'Semua Status';

  // List of items in our dropdown menu
  var items = [
    'Semua Status',
    'Belum Dibayar',
    'Diproses',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  String startDate = "";
  String endDate = "";

  bool isFiltered = false;
  String selectedStatusFilter = "";
  String selectedDateFilter = "";

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

    Widget transactionItem({required int index}) {
      var transaction = transactionModel.data?[index];
      String timestamp = "${transaction?.produk?.first.createdAt}";
      DateTime dateTime = DateTime.parse(timestamp);
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
      print("nama cabangnya adalah: ${transaction?.namaCabang}");
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
                            "Selesai"
                        ? Colors.green.withOpacity(0.2)
                        : "${transaction?.keteranganStatus}".toLowerCase() ==
                                "dibatalkan"
                            ? Colors.red.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "${transaction?.keteranganStatus}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                        color:
                            "${transaction?.keteranganStatus}".toLowerCase() ==
                                    "selesai"
                                ? Colors.green
                                : "${transaction?.keteranganStatus}"
                                            .toLowerCase() ==
                                        "dibatalkan"
                                    ? Colors.red
                                    : Colors.orange,
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
                                    context: context,
                                    message:
                                        "Anda yakin ingin mengubah status menjadi selesai?",
                                    onCancelPressed: () =>
                                        Navigator.pop(context),
                                    onConfirmPressed: () async {
                                      () async {
                                        if (await transaksiProvider
                                            .postStatustransaksi(
                                          token:
                                              loginProvider.loginModel.token ??
                                                  "",
                                          noInvoice:
                                              transaction?.noInvoice ?? "",
                                          status: 4,
                                        )) {
                                          _initTransaction();
                                          Navigator.pop(context);
                                        }
                                      };
                                    });
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
      return SizedBox(
        width: double.infinity,
        child: Column(
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
        ),
      );
    }

    // Widget filter() {
    //   return Container(
    //     margin: const EdgeInsets.symmetric(
    //       horizontal: 20,
    //     ),
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: Row(
    //         children: [
    //           DropdownButton(
    //             // Initial Value
    //             value: dropdownvalue,

    //             // Down Arrow Icon
    //             icon: const Icon(Icons.keyboard_arrow_down),

    //             // Array list of items
    //             items: items.map((String items) {
    //               return DropdownMenuItem(
    //                 value: items,
    //                 child: Text(items),
    //               );
    //             }).toList(),
    //             // After selecting the desired option,it will
    //             // change button value to selected value
    //             onChanged: (String? newValue) {
    //               setState(() {
    //                 dropdownvalue = newValue!;
    //                 int index = items.indexOf(newValue);
    //                 print("indexnya adalah ${index - 1}");
    //                 _initTransaction(
    //                     status: "${index - 1 < 0 ? "" : index - 1}");
    //               });
    //             },
    //           ),

    //           Container(
    //             decoration: BoxDecoration(boxShadow: []),
    //           )
    //           // Text(
    //           //   "Status",
    //           // ),
    //           // Text(
    //           //   "Status",
    //           // ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // ignore: no_leading_underscores_for_local_identifiers
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      setState(() {
        if (args.value is PickerDateRange) {
          isFiltered = true;
          // ignore: lines_longer_than_80_chars
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
          startDate =
              "${DateFormat('yyyy/MM/dd').format(args.value.startDate)}";
          endDate =
              "${DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate)}";
          selectedDateFilter = "$startDate - $endDate";
        }
      });
    }

    void filterModalBottomSheet({required String title}) {
      String indexFilter = "";
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(24),
            height: MediaQuery.sizeOf(context).height * 0.55,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  20,
                ),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                print("startDate: $startDate");
                return ListView(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            title.toLowerCase().contains("status")
                                ? "Mau lihat status apa?"
                                : "Pilih tanggal",
                            style: poppins.copyWith(
                              fontWeight: semiBold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        !title.toLowerCase().contains("tanggal")
                            ? const SizedBox()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: backgroundColor3,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isFiltered = false;
                                    selectedDateFilter = "";
                                    startDate = "";
                                    endDate = "";
                                    Navigator.pop(context);
                                    filterModalBottomSheet(title: title);
                                  });
                                },
                                child: Text(
                                  "Semua Tanggal",
                                  style: poppins,
                                )),
                      ],
                    ),
                    // NOTE: Mau lihat status apa?
                    if (title.toLowerCase().contains("status")) ...{
                      Wrap(
                        children: [
                          for (String item in items) ...{
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (title.toLowerCase().contains("status")) {
                                    indexFilter = (items.indexWhere(
                                                (element) => element == item) -
                                            1)
                                        .toString();
                                    indexFilter =
                                        indexFilter == "-1" ? "" : indexFilter;
                                  }
                                  isFiltered = true;
                                  selectedStatusFilter = item;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 20,
                                  right: 5,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: selectedStatusFilter == item
                                      ? backgroundColor3
                                      : Colors.grey.withAlpha(70),
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Text(
                                  item,
                                  style: poppins.copyWith(
                                      color: selectedStatusFilter == item
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          }
                        ],
                      )
                    }
                    // NOTE: Pilih Tanggal
                    else ...{
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary:
                                backgroundColor1, // header background color
                            onPrimary: Colors.white, // header text color
                          ),
                        ),
                        child: SfDateRangePicker(
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.range,
                          initialSelectedRange: startDate != ""
                              ? PickerDateRange(
                                  dateFormat.parse(startDate),
                                  dateFormat.parse(endDate),
                                )
                              : PickerDateRange(
                                  DateTime.now(),
                                  DateTime.now(),
                                ),
                        ),
                      ),
                    },
                  ],
                );
              },
            ),
          );
        },
      ).then((_) {
        if (indexFilter == "" && title.toLowerCase().contains("status")) {
          setState(() {
            isFiltered = false;
            selectedStatusFilter = "";
          });
        }
        _initTransaction(
          status: indexFilter,
          tanggalAwal: startDate,
          tanggalAkhir: endDate,
        );
      });
    }

    Widget filterItem({required String title}) {
      return InkWell(
        onTap: () {
          filterModalBottomSheet(title: title);
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 20,
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isFiltered &&
                    title.toLowerCase().contains("status") &&
                    selectedStatusFilter != ""
                ? backgroundColor3
                : isFiltered &&
                        title.toLowerCase().contains("tanggal") &&
                        selectedDateFilter != ""
                    ? backgroundColor3
                    : Colors.grey.withAlpha(70),
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Row(
            children: [
              Text(
                isFiltered &&
                        title.toLowerCase().contains("status") &&
                        selectedStatusFilter != ""
                    ? selectedStatusFilter
                    : isFiltered &&
                            title.toLowerCase().contains("tanggal") &&
                            selectedDateFilter != ""
                        ? selectedDateFilter
                        : title,
                style: poppins.copyWith(
                  color: isFiltered &&
                          title.toLowerCase().contains("status") &&
                          selectedStatusFilter != ""
                      ? Colors.white
                      : isFiltered &&
                              title.toLowerCase().contains("tanggal") &&
                              selectedDateFilter != ""
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isFiltered &&
                        title.toLowerCase().contains("status") &&
                        selectedStatusFilter != ""
                    ? Colors.white
                    : isFiltered &&
                            title.toLowerCase().contains("tanggal") &&
                            selectedDateFilter != ""
                        ? Colors.white
                        : Colors.black,
              ),
            ],
          ),
        ),
      );
    }

    Widget filter() {
      return Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(
                width: 24,
              ),

              if (!isFiltered) ...{
                const SizedBox(),
              } else ...{
                //NOTE : Cancel semua filter
                InkWell(
                  onTap: () {
                    setState(() {
                      isFiltered = false;
                      selectedDateFilter = "";
                      selectedStatusFilter = "";
                      startDate = "";
                      endDate = "";
                    });
                    _initTransaction();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: const Icon(
                      Icons.close,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),
              },

              // NOTE: Status
              filterItem(title: "Semua Status"),

              const SizedBox(
                width: 10,
              ),

              // NOTE: Tanggal
              filterItem(title: "Semua Tanggal"),

              const SizedBox(
                width: 24,
              ),
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    // int index = items.indexOf(dropdownvalue);
                    // print("indexnya adalah ${index - 1}");
                    // _initTransaction(
                    //     status: "${index - 1 < 0 ? "" : index - 1}");
                    _initTransaction();
                  },
                  color: backgroundColor1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filter(),
                      (transactionModel.data?.length ?? 0) == 0
                          ? Expanded(
                              child: emptyTransaction(),
                            )
                          : Expanded(
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
