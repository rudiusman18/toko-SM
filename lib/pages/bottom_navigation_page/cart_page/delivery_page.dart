import 'package:flutter/material.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/theme/theme.dart';

class Deliverypage extends StatefulWidget {
  final String namaCabang;
  final CartModel product;
  const Deliverypage(
      {super.key, required this.namaCabang, required this.product});

  @override
  State<Deliverypage> createState() => _DeliverypageState();
}

class _DeliverypageState extends State<Deliverypage> {
  @override
  void initState() {
    print("Delivery Page ${widget.namaCabang} dengan ${widget.product}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget alamatPengiriman() {
      return Container(
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
                        "ini isinya alamat",
                        style: poppins.copyWith(
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "ini isinya alamat lebih detail ini isinya alamat lebih detail ini isinya alamat lebih detail ini isinya alamat lebih detail",
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
      );
    }

    Widget productItem() {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.red,
              child: Image.asset(
                "assets/logo.png",
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
                      "nama produk disini",
                      style: poppins,
                    ),
                    Text(
                      "satuan x harga",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "Total Harga",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "\"catatan disini catatan disini catatan disini catatan disini catatan disini catatan disini catatan disini catatan disini catatan disini\"",
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

    Widget kurir() {
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
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Kurir Toko",
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
              value: "Rp sekian",
            ),
            ringkasanItem(
              title: "Total ongkos kirim",
              value: "Rp sekian",
            ),
            ringkasanItem(
              title: "Total belanja",
              value: "Rp sekian",
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
                    "Cabang Pusat",
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
            for (var i = 0; i < 5; i++) productItem(),
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
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor3,
              ),
              child: Text(
                "Pilih Pembayaran",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
