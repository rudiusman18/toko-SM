import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget profileData({required String title, required String value}) {
      return Container(
        color: Colors.red,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: poppins,
              ),
            ),
            Text(
              value,
              style: poppins,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  padding: const EdgeInsets.all(50),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/bag.png'),
                ),
                profileData(title: "Nama", value: "John Doe"),
                profileData(title: "Umur", value: "23 Tahun"),
                profileData(title: "Alamat", value: "Jakarta"),
                profileData(title: "Pekerjaan", value: "-"),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "LOGOUT",
                    style: poppins,
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
