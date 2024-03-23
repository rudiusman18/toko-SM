import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/pages/login_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:placeholder_images/placeholder_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    LoginModel userLogin = loginProvider.loginModel;

    String getInitials(String name) {
      // Split the name into individual words
      List<String> words = name.split(' ');

      // Initialize an empty string to store initials
      String initials = '';

      // Iterate through each word and extract the first letter
      for (int i = 0; i < words.length && i < 2; i++) {
        // Get the first letter of the word and add it to the initials string
        initials += words[i][0];
      }

      // Return the initials string
      return initials;
    }

    void showAlertDialog(BuildContext context) {
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
              "Anda yakin untuk melakukan logout?",
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
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.remove('loginData');
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          child: const LoginPage(),
                          type: PageTransitionType.fade),
                      (route) => false);
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

    Widget profileData({required String title, required String value}) {
      return Row(
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Pengguna",
          style: poppins,
        ),
        centerTitle: true,
        backgroundColor: backgroundColor3,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                    ),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor3,
                    ),
                    child: Center(
                      child: Text(
                        getInitials(
                          userLogin.data?.namaPelanggan ?? "-".toUpperCase(),
                        ),
                        style: poppins.copyWith(
                          fontWeight: bold,
                          fontSize: 80,
                        ),
                      ),
                    ),
                  ),
                  profileData(
                    title: "Nama",
                    value: userLogin.data?.namaPelanggan ?? "-",
                  ),
                  profileData(
                    title: "Nama Pengguna",
                    value: userLogin.data?.username ?? "-",
                  ),
                  profileData(
                      title: "Email",
                      value: userLogin.data?.emailPelanggan ?? "-"),
                  profileData(
                      title: "Telp",
                      value: userLogin.data?.telpPelanggan ?? "-"),
                  profileData(
                      title: "Jenis Kelamin",
                      value: userLogin.data?.jenisKelaminPelanggan ?? "-"),
                  profileData(
                      title: "Alamat",
                      value: userLogin.data?.alamatPelanggan ?? "-"),
                  ElevatedButton(
                    onPressed: () {
                      showAlertDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.logout),
                        Text(
                          "LOGOUT",
                          style: poppins,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
