import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:tokoSM/models/favorite_model.dart';
import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/product_detail/product_detail_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../theme/theme.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  FavoriteModel favoriteProduct = FavoriteModel();
  LoginModel loginModel = LoginModel();

  @override
  void initState() {
    super.initState();
    _initFavoriteProduct();
  }

  _initFavoriteProduct() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    if (await productProvider.getFavoriteProduct(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        favoriteProduct = productProvider.favoriteModel;
        loginModel = loginProvider.loginModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget verticalListItem(int i) {
      return Container(
        padding: EdgeInsets.only(
            bottom: i == (favoriteProduct.data?.length ?? 1) - 1 ? 20 : 0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: ProductDetailPage(
                  productId: "${(favoriteProduct.data?[i].produkId ?? 0)}",
                  imageURL: favoriteProduct.data?[i].imageUrl,
                  productLoct: loginModel.data?.namaCabang ?? "",
                  discountPercentage: favoriteProduct.data?[i].diskon == null
                      ? ""
                      : "${favoriteProduct.data?[i].diskon}%",
                  beforeDiscountPrice: favoriteProduct.data?[i].diskon == null
                      ? ""
                      : "${favoriteProduct.data?[i].harga}",
                  productName: favoriteProduct.data?[i].namaProduk,
                  productPrice: favoriteProduct.data?[i].diskon == null
                      ? "${favoriteProduct.data?[i].harga}"
                      : favoriteProduct.data?[i].hargaDiskon.toString(),
                  productStar: favoriteProduct.data?[i].rating.toString(),
                  isDiscount:
                      favoriteProduct.data?[i].diskon == null ? false : true,
                ),
                type: PageTransitionType.bottomToTop,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 8), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "${favoriteProduct.data?[i].imageUrl}",
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${favoriteProduct.data?[i].namaProduk}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: poppins.copyWith(
                            color: backgroundColor1,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          favoriteProduct.data?[i].diskon == null
                              ? "Rp ${currencyFormatter.format(favoriteProduct.data?[i].harga)}"
                              : "Rp ${currencyFormatter.format(favoriteProduct.data?[i].hargaDiskon)}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: poppins.copyWith(
                            color: backgroundColor1,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.star,
                              color: backgroundColor2,
                            ),
                            Text(
                              "${favoriteProduct.data?[i].rating}",
                              style: poppins.copyWith(
                                fontWeight: semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (favoriteProduct.data?[i].diskon == null
                          ? false
                          : true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  "Rp ${currencyFormatter.format(favoriteProduct.data?[i].harga)}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: poppins.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 10),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "${favoriteProduct.data?[i].diskon}%",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: poppins.copyWith(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.location_city,
                              color: backgroundColor2,
                            ),
                            Expanded(
                              child: Text(
                                "Cabang ${loginModel.data?.namaCabang ?? ""}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: poppins.copyWith(
                                  color: backgroundColor2,
                                  fontWeight: medium,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        padding: EdgeInsets.all(10),
        color: backgroundColor3,
        width: double.infinity,
        child: Column(
          children: [
            Text(
              "Wishlist",
              style: poppins.copyWith(
                color: Colors.white,
                fontWeight: semiBold,
                fontSize: 24,
              ),
            ),
            Text(
              "${favoriteProduct.data?.length} Produk",
              style: poppins.copyWith(
                color: Colors.white,
                fontWeight: light,
              ),
            ),
          ],
        ),
      );
    }

    Widget emptyWishlist() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/wishlist.png",
            width: 150,
            height: 150,
          ),
          Text(
            "OOPS...!",
            style: poppins.copyWith(
              fontSize: 50,
              fontWeight: semiBold,
              color: backgroundColor3,
            ),
          ),
          Text(
            "Wishlist anda kosong",
            style: poppins.copyWith(
              fontSize: 15,
              color: backgroundColor3,
              fontWeight: medium,
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            header(),
            Expanded(
              child: (favoriteProduct.data ?? []).isNotEmpty
                  ? ListView(
                      children: [
                        for (var i = 0;
                            i < (favoriteProduct.data?.length ?? 0);
                            i++)
                          verticalListItem(i),
                      ],
                    )
                  : emptyWishlist(),
            ),
          ],
        ),
      ),
    );
  }
}
