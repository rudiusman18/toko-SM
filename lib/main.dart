import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tokoSM/pages/splash_page.dart';
import 'package:tokoSM/providers/alamat_provider.dart';
import 'package:tokoSM/providers/cabang_provider.dart';
import 'package:tokoSM/providers/cart_provider.dart';
import 'package:tokoSM/providers/category_provider.dart';
import 'package:tokoSM/providers/kurir_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/metode_pembayaran_provider.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/providers/profile_provider.dart';
import 'package:tokoSM/providers/register_provider.dart';
import 'package:tokoSM/providers/transaksi_provider.dart';
import 'package:tokoSM/providers/ulasan_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => CabangProvider()),
        ChangeNotifierProvider(create: (context) => KurirProvider()),
        ChangeNotifierProvider(create: (context) => AlamatProvider()),
        ChangeNotifierProvider(create: (context) => MetodePembayaranProvider()),
        ChangeNotifierProvider(create: (context) => TransaksiProvider()),
        ChangeNotifierProvider(create: (context) => UlasanProvider()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        title: "Toko SM",
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'),
        ],
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: SplashPage(),
        ),
      ),
    );
  }
}
