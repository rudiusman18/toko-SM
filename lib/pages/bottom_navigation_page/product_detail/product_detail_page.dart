import 'package:carousel_slider/carousel_slider.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/providers/favorite_provider.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailPage extends StatefulWidget {
  final String imageURL;
  final String productName;
  final String productPrice;
  final String productStar;
  final String productLoct;
  final String? beforeDiscountPrice;
  final String? discountPercentage;
  final bool isDiscount;
  const ProductDetailPage(
      {super.key,
      required this.imageURL,
      required this.productName,
      required this.productPrice,
      required this.productStar,
      required this.productLoct,
      required this.isDiscount,
      this.beforeDiscountPrice,
      this.discountPercentage});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  FToast fToast = FToast();
  int carouselIndex = 0;
  double headerAlpha = 0.0;

  @override
  void initState() {
    super.initState();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);
  }

  void dispose() {
    super.dispose();
    fToast.removeCustomToast();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    // list.firstWhere((a) => a == b, orElse: () => print('No matching element.'));
    // ProductModel wishlist = productProvider.wishlistData.firstWhere((element) => element.urlImg == widget.imageURL, orElse: ()=> ProductModel());
    Widget toast({required String message, required void Function() onTap}) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: poppins.copyWith(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            InkWell(
              onTap: onTap,
              child: Text(
                "Lihat detail",
                style: poppins.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: 10,
                ),
              ),
            )
          ],
        ),
      );
    }

    // Widget headerNavigation() {
    //   return AnimatedContainer(
    //     duration: const Duration(milliseconds: 300),
    //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //     color: backgroundColor3.withAlpha((headerAlpha * 255).round()),
    //     child: Row(
    //       children: [
    //         InkWell(
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //           child: Container(
    //             padding: const EdgeInsets.all(10),
    //             child: const Icon(
    //               Icons.arrow_back,
    //               color: Colors.white,
    //               size: 30,
    //             ),
    //           ),
    //         ),
    //         const Spacer(),
    //         InkWell(
    //           onTap: () {
    //             fToast.removeCustomToast();
    //             pageProvider.currentIndex = 4;
    //             Navigator.push(
    //               context,
    //               PageTransition(
    //                 child: const MainPage(),
    //                 type: PageTransitionType.bottomToTop,
    //               ),
    //             ).then((value) => setState(() {
    //                   pageProvider.currentIndex = 0;
    //                 }));
    //           },
    //           child: Container(
    //             padding: const EdgeInsets.all(10),
    //             child: const Icon(
    //               Icons.shopping_cart,
    //               color: Colors.white,
    //               size: 30,
    //             ),
    //           ),
    //         ),
    //         InkWell(
    //           onTap: () {
    //             setState(
    //               () {
    //                 fToast.removeCustomToast();
    //                 favoriteProvider.isFavorite =
    //                     wishlist.isFavorite == null ? true : false;

    //                 if (favoriteProvider.isFavorite) {
    //                   productProvider.wishlistData.removeWhere(
    //                       (element) => element.urlImg == widget.imageURL);
    //                   productProvider.wishlistData.add(ProductModel(
    //                     productName: widget.productName,
    //                     productPrice: widget.productPrice,
    //                     isDiscount: widget.isDiscount,
    //                     beforeDiscountPrice: widget.beforeDiscountPrice,
    //                     discountPercentage: widget.discountPercentage,
    //                     urlImg: widget.imageURL,
    //                     isFavorite: favoriteProvider.isFavorite,
    //                     isAddtoCart: false,
    //                   ));

    //                   for (var data in productProvider.wishlistData) {
    //                     print(
    //                         "wishlist data yang dimasukkan adalah ${data.urlImg} dengan jumlah ${productProvider.wishlistData.length}");
    //                   }

    //                   fToast.showToast(
    //                     child: toast(
    //                       message: "1 barang berhasil ditambahkan",
    //                       onTap: () {
    //                         fToast.removeCustomToast();
    //                         pageProvider.currentIndex = 2;
    //                         Navigator.pushAndRemoveUntil(
    //                             context,
    //                             PageTransition(
    //                               child: const MainPage(),
    //                               type: PageTransitionType.bottomToTop,
    //                             ),
    //                             (route) => false);
    //                       },
    //                     ),
    //                     toastDuration: const Duration(seconds: 2),
    //                     gravity: ToastGravity.CENTER,
    //                   );
    //                 } else {
    //                   productProvider.wishlistData.removeWhere(
    //                       (element) => element.urlImg == widget.imageURL);
    //                 }
    //               },
    //             );
    //           },
    //           child: Container(
    //             padding: const EdgeInsets.all(10),
    //             child: Icon(
    //               wishlist.isFavorite == false || wishlist.isFavorite == null
    //                   ? Icons.favorite_border
    //                   : Icons.favorite,
    //               color: Colors.white,
    //               size: 30,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget header() {
      return Stack(
        children: [
          CarouselSlider(
            items: [
              for (var i = 0; i < 5; i++)
                Image.network(
                  widget.imageURL,
                  height: MediaQuery.sizeOf(context).width,
                  width: MediaQuery.sizeOf(context).width,
                  fit: BoxFit.cover,
                ),
            ],
            options: CarouselOptions(
                height: MediaQuery.sizeOf(context).width * 0.75,
                initialPage: 0,
                enableInfiniteScroll: false,
                padEnds: false,
                viewportFraction: 1,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.linear,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    carouselIndex = index;
                  });
                }),
          ),
          Container(
            height: MediaQuery.sizeOf(context).width * 0.68,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 10),
            child: AnimatedSmoothIndicator(
              activeIndex: carouselIndex,
              count: 5,
              effect: WormEffect(
                activeDotColor: backgroundColor2,
                dotColor: Colors.white,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
        ],
      );
    }

    Widget productDetailsContent(String key, String value) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key,
                  style: poppins.copyWith(fontWeight: semiBold),
                ),
                Text(
                  value,
                  style: poppins.copyWith(
                    color: backgroundColor1,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            )
          ],
        ),
      );
    }

    Widget productReviewContent() {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColor2,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: poppins.copyWith(fontWeight: semiBold),
                    ),
                    Text(
                      "247 Ulasan - 8 Terbantu",
                      style: poppins.copyWith(
                          fontWeight: light, fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RatingStars(
                    value: 5.0,
                    onValueChanged: (v) {
                      //
                      setState(() {
                        // value = v;
                      });
                    },
                    starBuilder: (index, color) => Icon(
                      Icons.star,
                      color: color,
                    ),
                    starCount: 5,
                    starSize: 20,
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: medium,
                      fontStyle: FontStyle.normal,
                    ),
                    valueLabelRadius: 10,
                    maxValue: 5,
                    starSpacing: 2,
                    maxValueVisibility: true,
                    valueLabelVisibility: false,
                    animationDuration: const Duration(milliseconds: 1000),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: backgroundColor2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "2 Bulan lalu",
                      style: poppins.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit amet tes komentar",
                style: poppins,
              ),
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width * 0.7),
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 30,
          bottom: 80,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productPrice,
              style: poppins.copyWith(
                fontSize: 24,
                fontWeight: bold,
                color: backgroundColor1,
              ),
            ),
            if (widget.isDiscount)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        widget.beforeDiscountPrice.toString(),
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
                        widget.discountPercentage.toString(),
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
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.productName,
                style: poppins.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                  color: backgroundColor1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
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
                      widget.productLoct,
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RatingStars(
                value: double.parse(widget.productStar),
                onValueChanged: (v) {
                  //
                  setState(() {
                    // value = v;
                  });
                },
                starBuilder: (index, color) => Icon(
                  Icons.star,
                  color: color,
                ),
                starCount: 5,
                starSize: 20,
                valueLabelColor: const Color(0xff9b9b9b),
                valueLabelTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: medium,
                  fontStyle: FontStyle.normal,
                ),
                valueLabelRadius: 10,
                maxValue: 5,
                starSpacing: 2,
                maxValueVisibility: true,
                valueLabelVisibility: true,
                animationDuration: const Duration(milliseconds: 1000),
                valueLabelPadding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                valueLabelMargin: const EdgeInsets.only(right: 8, top: 5),
                starOffColor: const Color(0xffe7e8ea),
                starColor: backgroundColor2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ReadMoreText(
                "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.\n",
                style: poppins.copyWith(
                  fontWeight: light,
                ),
                trimLines: 5,
                colorClickableText: backgroundColor1,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Lebih banyak',
                trimExpandedText: 'Lebih sedikit',
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Detail Produk",
                style: poppins.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                  color: backgroundColor1,
                ),
              ),
            ),
            productDetailsContent("Kondisi", "Baru"),
            productDetailsContent("Min. Pembelian", "1 Buah"),
            productDetailsContent("Kategori", "Makanan & Minuman"),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ulasan",
                    style: poppins.copyWith(
                      fontSize: 24,
                      fontWeight: bold,
                      color: backgroundColor1,
                    ),
                  ),
                  Text(
                    "Lihat Semua",
                    style: poppins.copyWith(
                      color: backgroundColor1,
                    ),
                  ),
                ],
              ),
            ),
            productReviewContent(),
          ],
        ),
      );
    }

    // Widget addToCartButton() {
    //   return Container(
    //     color: Colors.white,
    //     width: double.infinity,
    //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    //     child: TextButton(
    //         onPressed: () {
    //           CartModel cart = productProvider.cartData.firstWhere(
    //               (element) => element.product?.urlImg == widget.imageURL,
    //               orElse: () => CartModel(numberOfItem: 0));
    //           if (cart.numberOfItem == 0) {
    //             print("object ${widget.beforeDiscountPrice}");
    //             productProvider.cartData.add(
    //               CartModel(
    //                   product: ProductModel(
    //                     productName: widget.productName,
    //                     productPrice: widget.productPrice,
    //                     isDiscount: widget.isDiscount,
    //                     beforeDiscountPrice: widget.beforeDiscountPrice,
    //                     discountPercentage: widget.discountPercentage,
    //                     urlImg: widget.imageURL,
    //                     isFavorite: favoriteProvider.isFavorite,
    //                     isAddtoCart: false,
    //                   ),
    //                   numberOfItem: 1),
    //             );
    //           } else {
    //             cart.product?.productPrice = widget.productPrice;
    //             cart.product?.isDiscount = widget.isDiscount;
    //             cart.product?.beforeDiscountPrice = widget.beforeDiscountPrice;
    //             cart.product?.discountPercentage = widget.discountPercentage;
    //             cart.numberOfItem += 1;
    //           }

    //           fToast.showToast(
    //             child: toast(
    //               message: "1 barang berhasil ditambahkan",
    //               onTap: () {
    //                 fToast.removeCustomToast();
    //                 pageProvider.currentIndex = 4;
    //                 Navigator.pushAndRemoveUntil(
    //                     context,
    //                     PageTransition(
    //                       child: const MainPage(),
    //                       type: PageTransitionType.bottomToTop,
    //                     ),
    //                     (route) => false);
    //               },
    //             ),
    //             toastDuration: const Duration(seconds: 2),
    //             gravity: ToastGravity.CENTER,
    //           );
    //         },
    //         style: TextButton.styleFrom(
    //           backgroundColor: backgroundColor3,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(30)),
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               const Icon(
    //                 Icons.shopping_cart,
    //                 color: Colors.white,
    //               ),
    //               Text(
    //                 "Masukkan Keranjang",
    //                 style: poppins.copyWith(
    //                     fontWeight: medium, color: Colors.white),
    //               ),
    //             ],
    //           ),
    //         )),
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollUpdateNotification) {
                  setState(() {
                    // Calculate the new alpha value based on scroll position
                    double newAlpha = 0.0 +
                        (scrollInfo.metrics.pixels /
                            scrollInfo.metrics.maxScrollExtent);

                    if (newAlpha > 0.0) {
                      newAlpha = 1;
                    }
                    // Limit alpha to be in the range [0, 1]
                    headerAlpha = newAlpha.clamp(0.0, 1.0);
                  });
                }
                return false;
              },
              child: ListView(
                children: [
                  Stack(
                    children: [
                      header(),
                      content(),
                    ],
                  ),
                ],
              ),
            ),
            // headerNavigation(),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: addToCartButton(),
            // ),
          ],
        ),
      ),
    );
  }
}
