import 'dart:async';

import 'package:e_shop/pages/main_page.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainPage()), (route)=>false);
    });

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: backgroundColor3,
      child:  Stack(
        alignment: Alignment.bottomCenter,
          children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/shopping-cart.png",
                height: 100,
                // width: 100,
              ),
              Text(
                "Lorem Ipsum",
                style: poppins.copyWith(
                  color: Colors.white,
                  fontWeight: bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),

            ],
          ),
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
