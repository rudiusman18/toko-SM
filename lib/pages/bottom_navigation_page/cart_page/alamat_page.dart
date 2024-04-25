import 'package:flutter/material.dart';
import 'package:tokoSM/theme/theme.dart';

class AlamatPage extends StatelessWidget {
  const AlamatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Alamat"),
        backgroundColor: backgroundColor3,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10,),
              child: Center(child: Text("Tambah Alamat",))),
        ],
      ),
      body: Center(
        child: Text("Ini adalah halaman alamat"),
      ),
    );
  }
}
