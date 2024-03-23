import 'package:tokoSM/pages/splash_page.dart';
import 'package:tokoSM/providers/favorite_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        title: "Toko SM",
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: SplashPage(),
        ),
      ),
    );
  }
}
