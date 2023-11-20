import 'dart:ffi';

import 'package:e_shop/pages/bottom_navigation_page/product_detail/product_detail_page.dart';
import 'package:e_shop/providers/product_provider.dart';
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

  @override
  Widget build(BuildContext context) {

    ProductProvider wishlistProductProvider = Provider.of<ProductProvider>(context);

    Widget verticalListItem(String imageUrl, int numberContent, ProductModel product, {bool isOnDiscountContent = false}){
      return InkWell(
        onTap: (){
          Navigator.push(
            context,
            PageTransition(
              child: ProductDetailPage(
                imageURL: product.urlImg.toString(),
                productLoct: "Cabang Malang Kota",
                productName: product.productName.toString(),
                productPrice: product.productPrice.toString(),
                productStar: "4.5",
                isDiscount: isOnDiscountContent,
                discountPercentage: product.discountPercentage,
                beforeDiscountPrice: product.beforeDiscountPrice,
              ),
              type: PageTransitionType.bottomToTop,
            ),
          ).then((_){
            setState(() {});
          });
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: numberContent == 0 ? 30 : 5, bottom: numberContent == 19 ? 30 : 5),
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset:  const Offset(0, 8), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
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
                        "${product.productName}",
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
                        "Rp 18,000.00",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: poppins.copyWith(
                          color: backgroundColor1,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),

                    if(isOnDiscountContent == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "Rp 180,000.00",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: poppins.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 10
                                ),
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                "50%",
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
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star,
                            color: backgroundColor2,
                          ),
                          Text(
                            "4.5",
                            style: poppins.copyWith(
                              fontWeight: semiBold,
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
                              "Cab. Malang Kota",
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

              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor3,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget header(){
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
              "${wishlistProductProvider.wishlistData.length} Produk",
              style: poppins.copyWith(
                color: Colors.white,
                fontWeight: light,
              ),
            ),

          ],
        ),
      );
    }

    Widget emptyWishlist(){
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
              child: wishlistProductProvider.wishlistData.isNotEmpty ?
              ListView(
                    children: [
                      for (var i=0; i<wishlistProductProvider.wishlistData.length; i++)
                        verticalListItem(wishlistProductProvider.wishlistData[i].urlImg.toString(), i, wishlistProductProvider.wishlistData[i], isOnDiscountContent: wishlistProductProvider.wishlistData[i].isDiscount!)
                    ],
                  ) : emptyWishlist(),
            ),
          ],
        ),
      ),
    );
  }
}
