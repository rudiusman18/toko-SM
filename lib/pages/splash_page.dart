import 'dart:async';
import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/models/user_local_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/home_page.dart';
import 'package:tokoSM/pages/login_page.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late UserLocalModel userLocal;
  LoginModel user = LoginModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginProvider loginProvider = Provider.of(context, listen: false);
    Future.delayed(Duration.zero, () async {
      userLocal = await loginProvider.getModelFromPrefs() ?? UserLocalModel();
      if (await loginProvider.postLogin(
          email: userLocal.email ?? "", password: userLocal.password ?? "")) {
        user = loginProvider.loginModel;
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    user.data != null ? const MainPage() : const LoginPage()),
            (route) => false);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    user.data != null ? const MainPage() : const LoginPage()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: backgroundColor3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            // height: 250,
            width: 250,
          ),
          Text(
            "Toko SM",
            style: poppins.copyWith(
              color: Colors.white,
              fontWeight: bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 20,
            ),
            width: 30,
            height: 30,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
