import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/category_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/transaction_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/wishlist_page.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation_page/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime? currentBackPressTime = null;

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of(context);

    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const CategoryPage();
        case 2:
          return const WishlistPage();
        case 3:
          return const TransactionPage();
        default:
          return const HomePage();
      }
    }

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            currentIndex: pageProvider.currentIndex,
            onTap: (value) {
              setState(() {
                pageProvider.currentIndex = value;
              });
            },
            backgroundColor: backgroundColor3,
            selectedLabelStyle: poppins.copyWith(
              fontSize: 10,
            ),
            selectedItemColor: Colors.white,
            unselectedLabelStyle: poppins,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  child: Icon(
                    Icons.home_filled,
                    size: 25,
                    color: pageProvider.currentIndex == 0
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  child: Icon(
                    Icons.view_cozy_rounded,
                    size: 25,
                    color: pageProvider.currentIndex == 1
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "Kategori",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  child: Icon(
                    Icons.favorite,
                    size: 25,
                    color: pageProvider.currentIndex == 2
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  child: Icon(
                    Icons.paid,
                    size: 25,
                    color: pageProvider.currentIndex == 3
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "Transaksi",
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime ?? DateTime.now()) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: "tekan sekali lagi untuk keluar");
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white, //backgroundColor3,
          bottomNavigationBar: customBottomNav(),
          body: body(),
        ),
      ),
    );
  }
}
