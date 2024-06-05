// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/pages/login_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/profile_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  TextEditingController passwordLamaTextField = TextEditingController();
  TextEditingController passwordbaruTextField = TextEditingController();
  bool passwordLamaIsVisible = false;
  bool passwordBaruIsVisible = false;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    Widget customtextFormField({
      required IconData icon,
      required String title,
      required TextInputType keyboardType,
      required TextEditingController controller,
      bool readOnly = false,
      required int index,
    }) {
      return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: poppins.copyWith(
                fontWeight: medium,
                fontSize: 14,
                color: backgroundColor1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              readOnly: readOnly,
              textInputAction: TextInputAction.next,
              style: poppins.copyWith(
                color: backgroundColor1,
              ),
              keyboardType: keyboardType,
              cursorColor: backgroundColor1,
              controller: controller,
              obscureText:
                  index == 0 ? !passwordLamaIsVisible : !passwordBaruIsVisible,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintText: "...",
                hintStyle: poppins.copyWith(
                  color: backgroundColor1,
                ),
                prefixIcon: Icon(icon),
                suffixIcon: IconButton(
                  icon: (index == 0
                          ? passwordLamaIsVisible
                          : passwordBaruIsVisible)
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      index == 0
                          ? (passwordLamaIsVisible = !passwordLamaIsVisible)
                          : (passwordBaruIsVisible = !passwordBaruIsVisible);
                    });
                  },
                ),
                suffixIconColor: backgroundColor1,
                prefixIconColor: backgroundColor1,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor1,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor3,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Kata Sandi",
          style: poppins,
        ),
        backgroundColor: backgroundColor3,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView(
          children: [
            customtextFormField(
              icon: Icons.lock,
              title: "Password Lama",
              keyboardType: TextInputType.visiblePassword,
              controller: passwordLamaTextField,
              index: 0,
            ),
            customtextFormField(
              icon: Icons.lock,
              title: "Password baru",
              keyboardType: TextInputType.visiblePassword,
              controller: passwordbaruTextField,
              index: 1,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextButton(
                onPressed: () async {
                  print("Handle tap dijalankan");
                  setState(() {
                    isLoading = true;
                  });
                  if (await profileProvider.updatePassword(
                    token: loginProvider.loginModel.token ?? "",
                    passwordLama: passwordLamaTextField.text,
                    passwordBaru: passwordbaruTextField.text,
                  )) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${profileProvider.changePasswordMessage}",
                        ),
                      ),
                    );

                    if ("${profileProvider.changePasswordMessage}"
                        .contains("success")) {
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                child: const LoginPage(),
                                type: PageTransitionType.bottomToTop),
                            (route) => false);
                      });
                    }
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Gagal Mengubah Password",
                        ),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: backgroundColor3,
                ),
                child: Text(
                  "Konfirmasi",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
