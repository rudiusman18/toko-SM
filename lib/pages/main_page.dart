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
  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of(context);

    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return HomePage();
        case 1:
          return const CategoryPage();
        case 2:
          return const WishlistPage();
        case 3:
          return const TransactionPage();
        case 4:
          return const CartPage();
        default:
          return HomePage();
      }
    }

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
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
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.home_filled,
                    size: 30,
                    color: pageProvider.currentIndex == 0
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.view_list,
                    size: 30,
                    color: pageProvider.currentIndex == 1
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.favorite,
                    size: 30,
                    color: pageProvider.currentIndex == 2
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.paid,
                    size: 30,
                    color: pageProvider.currentIndex == 3
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: pageProvider.currentIndex == 4
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                label: "",
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, //backgroundColor3,
        bottomNavigationBar: customBottomNav(),
        body: body(),
      ),
    );
  }
}
