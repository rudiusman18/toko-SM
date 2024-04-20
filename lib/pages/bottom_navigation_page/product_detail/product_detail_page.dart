import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:tokoSM/models/detail_product_model.dart';
import 'package:tokoSM/models/favorite_model.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class ProductDetailPage extends StatefulWidget {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  final String? imageURL;
  final String? productId;
  final String? productName;
  final String? productPrice;
  final String? productStar;
  String? productLoct;
  final String? beforeDiscountPrice;
  final String? discountPercentage;
  final bool? isDiscount;

  ProductDetailPage(
      {super.key,
      this.imageURL,
      this.productId,
      this.productName,
      this.productPrice,
      this.productStar,
      this.productLoct,
      this.isDiscount,
      this.beforeDiscountPrice,
      this.discountPercentage});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  FToast fToast = FToast();
  int carouselIndex = 0;
  double headerAlpha = 0.0;

  // detail data product
  bool isLoading = false;
  DetailProductModel detailProduct = DetailProductModel();
  FavoriteModel favoriteProduct = FavoriteModel();

  @override
  void initState() {
    super.initState();
    _getDetailproduct();
    _getFavoriteProduct();
    fToast.init(context);
  }

  _getDetailproduct() async {
    setState(() {
      isLoading = true;
    });
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    if (await productProvider.getDetailProduct(
        productId: widget.productId ?? "",
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        isLoading = false;
        detailProduct = productProvider.detailProductModel;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  _getFavoriteProduct() async {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    if (await productProvider.getFavoriteProduct(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        favoriteProduct = productProvider.favoriteModel;
        favoriteProduct.data = favoriteProduct.data
            ?.where((element) =>
                element.namaProduk?.toLowerCase() ==
                widget.productName?.toLowerCase())
            .toList();
      });

      print(
          "isi favorite page untuk product ${widget.productName} adalah ${favoriteProduct.data}");
    } else {
      print("ada yang salah dengan logikamu");
    }
  }

  @override
  void dispose() {
    super.dispose();
    fToast.removeCustomToast();
  }

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

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

    Widget headerNavigation() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: backgroundColor3.withAlpha((headerAlpha * 255).round()),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                fToast.removeCustomToast();
                pageProvider.currentIndex = 4;
                Navigator.push(
                  context,
                  PageTransition(
                    child: const MainPage(),
                    type: PageTransitionType.bottomToTop,
                  ),
                ).then((value) => setState(() {
                      pageProvider.currentIndex = 0;
                    }));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {});
                fToast.removeCustomToast();
                if (favoriteProduct.data?.isEmpty ?? true) {
                  await productProvider.postFavoriteProduct(
                    token: loginProvider.loginModel.token ?? "",
                    productId: widget.productId.toString(),
                  );
                  _getFavoriteProduct();
                  fToast.showToast(
                    child: toast(
                      message: "1 barang berhasil ditambahkan",
                      onTap: () {
                        fToast.removeCustomToast();
                        pageProvider.currentIndex = 2;
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              child: const MainPage(),
                              type: PageTransitionType.bottomToTop,
                            ),
                            (route) => false);
                      },
                    ),
                    toastDuration: const Duration(seconds: 2),
                    gravity: ToastGravity.CENTER,
                  );
                } else {
                  await productProvider.deleteFavoriteProduct(
                    token: loginProvider.loginModel.token ?? "",
                    productId: widget.productId.toString(),
                  );
                  _getFavoriteProduct();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  favoriteProduct.data?.isEmpty ?? true
                      ? Icons.favorite_border
                      : Icons.favorite,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget header() {
      int numberofItems = detailProduct.data?.gambar?.length ?? 0;
      return Stack(
        children: [
          CarouselSlider(
            items: [
              for (int i = 0; i < numberofItems; i++)
                Image.network(
                  detailProduct.data != null
                      ? "${detailProduct.data?.gambar?[i]}"
                      : widget.imageURL ?? "",
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
            padding: const EdgeInsets.only(
              left: 20,
            ),
            height: MediaQuery.sizeOf(context).width * 0.68,
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: backgroundColor3,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${carouselIndex + 1}/$numberofItems",
                style: poppins.copyWith(
                  fontWeight: light,
                  color: Colors.white,
                ),
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
      List<String> dataCabang = <String>[];
      var numberofStocks = detailProduct.data?.stok?.length ?? 0;
      if ((detailProduct.data?.stok?.length ?? 0) <= 0) {
        dataCabang.add(widget.productLoct ?? "Pusat");
      } else {
        dataCabang.clear();
        for (int i = 0; i < numberofStocks; i++) {
          dataCabang.add("${detailProduct.data?.stok?[i].cabang}");
        }
      }
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
              "Rp ${widget.currencyFormatter.format(int.parse((detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.diskon ?? 0).toString() == "0" ? (detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.harga ?? 0).toString() : (detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.hargaDiskon ?? 0).toString()))}",
              style: poppins.copyWith(
                fontSize: 24,
                fontWeight: bold,
                color: backgroundColor1,
              ),
            ),
            if ((detailProduct.data?.harga
                    ?.where((element) =>
                        element.cabang?.toLowerCase() ==
                        widget.productLoct?.toLowerCase())
                    .first
                    .diskon) !=
                null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        "Rp ${widget.currencyFormatter.format(int.parse((detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.harga ?? 0).toString()))}",
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
                        "${(detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.diskon ?? 0)}%"
                            .toString(),
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
                widget.productName ?? "",
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_city,
                    color: backgroundColor2,
                    size: 40,
                  ),
                  Text(
                    "Cabang ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: poppins.copyWith(
                      color: backgroundColor2,
                      fontWeight: medium,
                    ),
                  ),
                  DropdownMenu<String>(
                    initialSelection: widget.productLoct,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        widget.productLoct = value!;
                        print(' value $value');
                      });
                    },
                    dropdownMenuEntries: dataCabang
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RatingStars(
                value: double.parse(widget.productStar ?? "0"),
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
                "${detailProduct.data?.deskripsiProduk}",
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
            productDetailsContent("Merk", "${detailProduct.data?.merkProduk}"),
            productDetailsContent(
                "Satuan", "${detailProduct.data?.satuanProduk}"),
            productDetailsContent(
                "Golongan", "${detailProduct.data?.golonganProduk}"),
            productDetailsContent("Stok",
                "${detailProduct.data?.stok?.where((element) => element.cabang?.toLowerCase() == "${widget.productLoct?.toLowerCase()}").first.stok}"),
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
                  // Text(
                  //   "Lihat Semua",
                  //   style: poppins.copyWith(
                  //     color: backgroundColor1,
                  //   ),
                  // ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  "Produk ini belum memiliki ulasan",
                  style: poppins,
                ),
              ),
            ),
            // productReviewContent(),
          ],
        ),
      );
    }

    Widget addToCartButton() {
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: TextButton(
            onPressed: () {
              // CartModel
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  Text(
                    "Masukkan Keranjang",
                    style: poppins.copyWith(
                        fontWeight: medium, color: Colors.white),
                  ),
                ],
              ),
            )),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollUpdateNotification &&
                    scrollInfo.metrics.axis == Axis.vertical) {
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
            headerNavigation(),
            Align(
              alignment: Alignment.bottomCenter,
              child: addToCartButton(),
            ),
          ],
        ),
      ),
    );
  }
}
