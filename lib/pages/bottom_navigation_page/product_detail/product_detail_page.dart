// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:tokoSM/models/detail_product_model.dart';
import 'package:tokoSM/models/favorite_model.dart';
import 'package:tokoSM/models/ulasan_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/product_detail/ulasan_product_page.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/providers/cart_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/page_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:tokoSM/providers/ulasan_provider.dart';
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
  final bool? isFavoriteDetail;
  final List<int>? jumlahMultiSatuan;

  ProductDetailPage({
    super.key,
    this.imageURL,
    this.productId,
    this.productName,
    this.productPrice,
    this.productStar,
    this.productLoct,
    this.isDiscount,
    this.beforeDiscountPrice,
    this.discountPercentage,
    this.isFavoriteDetail = false,
    this.jumlahMultiSatuan,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  FToast fToast = FToast();
  int carouselIndex = 0;
  double headerAlpha = 0.0;

  // detail data product
  bool isLoading = false;
  bool initLoading = false;
  bool favoriteLoading = false;
  bool ulasanProductIsLoading = false;
  DetailProductModel detailProduct = DetailProductModel();
  FavoriteModel favoriteProduct = FavoriteModel();
  UlasanModel ulasanProduct = UlasanModel();

  @override
  void initState() {
    super.initState();
    _getDetailproduct();
    _getFavoriteProduct();
    _getUlasanProduct();
    fToast.init(context);
  }

  _getDetailproduct() async {
    setState(() {
      initLoading = true;
    });
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    if (await productProvider.getDetailProduct(
        productId: widget.productId ?? "",
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        initLoading = false;
        detailProduct = productProvider.detailProductModel;
      });
    } else {
      setState(() {
        initLoading = false;
      });
    }
  }

  _getFavoriteProduct() async {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    setState(() {
      favoriteLoading = true;
    });
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
      setState(() {
        favoriteLoading = false;
      });

      print(
          "isi favorite page untuk product ${widget.productName} adalah ${favoriteProduct.data}");
    } else {
      print("ada yang salah dengan logikamu");
      setState(() {
        favoriteLoading = false;
      });
    }
  }

  _getUlasanProduct() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    UlasanProvider ulasanProvider =
        Provider.of<UlasanProvider>(context, listen: false);
    setState(() {
      ulasanProductIsLoading = true;
    });
    if (await ulasanProvider.getUlasanProduct(
        token: loginProvider.loginModel.token ?? "",
        productId: int.parse(widget.productId.toString()))) {
      print("Ulasan Product ${ulasanProvider.ulasanProduct}");
      setState(() {
        ulasanProduct = ulasanProvider.ulasanProduct;
        ulasanProductIsLoading = false;
      });
    } else {
      setState(() {
        ulasanProductIsLoading = false;
      });
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
    CartProvider cartProvider = Provider.of<CartProvider>(context);

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
        color: backgroundColor3, //.withAlpha((headerAlpha * 255).round()),
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
                Navigator.push(
                    context,
                    PageTransition(
                        child: const CartPage(),
                        type: PageTransitionType.rightToLeft));
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
                  setState(() {
                    favoriteLoading = true;
                  });
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
                  setState(() {
                    favoriteLoading = true;
                  });
                  await productProvider.deleteFavoriteProduct(
                    token: loginProvider.loginModel.token ?? "",
                    productId: widget.productId.toString(),
                  );
                  _getFavoriteProduct();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: favoriteLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Icon(
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
                Flexible(
                  flex: 2,
                  child: Text(
                    key,
                    style: poppins.copyWith(fontWeight: medium),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    value,
                    style: poppins.copyWith(
                      color: backgroundColor1,
                    ),
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

    Widget productReviewContent({
      required String namaPengguna,
      required int rating,
      required String ulasan,
      required String tanggalUlasan,
    }) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(tanggalUlasan);
      print("isi tanggalnya: ${dateTime} dengan $tanggalUlasan");
      String timeAgo(DateTime date) {
        Duration diff = DateTime.now().difference(date);

        if (diff.inDays >= 365) {
          int years = (diff.inDays / 365).floor();
          return years == 1 ? '1 tahun yang lalu' : '$years tahun yang lalu';
        } else if (diff.inDays >= 30) {
          int months = (diff.inDays / 30).floor();
          return months == 1 ? '1 bulan yang lalu' : '$months bulan yang lalu';
        } else if (diff.inDays >= 7) {
          int weeks = (diff.inDays / 7).floor();
          return weeks == 1 ? '1 minggu yang lalu' : '$weeks minggu yang lalu';
        } else if (diff.inDays > 0) {
          return diff.inDays == 1
              ? '1 hari yang lalu'
              : '${diff.inDays} hari yang lalu';
        } else if (diff.inHours > 0) {
          return diff.inHours == 1
              ? '1 jam yang lalu'
              : '${diff.inHours} jam yang lalu';
        } else if (diff.inMinutes > 0) {
          return diff.inMinutes == 1
              ? '1 menit yang lalu'
              : '${diff.inMinutes} menit yang lalu';
        } else {
          return 'Baru saja';
        }
      }

      return Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
        ),
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
                Text(
                  namaPengguna,
                  style: poppins.copyWith(fontWeight: semiBold),
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
                    value: double.parse("$rating"),
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
                      timeAgo(dateTime),
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
                ulasan,
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
          top: 20,
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOTE: Section 1: Nama Produk, diskon, harga, rating, dan jumlah ulasan
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName ?? "",
                    style: poppins.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                      color: backgroundColor1,
                    ),
                  ),
                  Text(
                    "Rp ${widget.currencyFormatter.format(int.parse((detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.diskon ?? 0).toString() == "0" ? (detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.harga ?? 0).toString() : (detailProduct.data?.harga?.where((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).first.hargaDiskon ?? 0).toString()))}",
                    style: poppins.copyWith(
                      fontSize: 17,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.yellow,
                      ),
                      Text(
                        "${detailProduct.data?.rating} | ${ulasanProduct.data?.length ?? 0} Ulasan",
                        style: poppins.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),

            // NOTE: Section 2: Informasi Stok
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informasi Stok",
                    style: poppins.copyWith(
                      fontWeight: semiBold,
                      fontSize: 16,
                      color: backgroundColor1,
                    ),
                  ),
                  for (var i = 0;
                      i < (detailProduct.data?.stok?.length ?? 0);
                      i++) ...{
                    Row(
                      children: [
                        Icon(
                          detailProduct.data?.stok?[i].stok == null ||
                                  (detailProduct.data?.stok?[i].stok ?? 0) < 1
                              ? Icons.close_rounded
                              : Icons.check_circle,
                          color: detailProduct.data?.stok?[i].stok == null ||
                                  (detailProduct.data?.stok?[i].stok ?? 0) < 1
                              ? Colors.red
                              : backgroundColor3,
                        ),
                        Text(
                          "${detailProduct.data?.stok?[i].cabang} ${detailProduct.data?.stok?[i].cabang?.toLowerCase() == widget.productLoct?.toLowerCase() ? "(terpilih)" : ""}",
                          style: poppins,
                        ),
                        const Spacer(),
                        Text(
                          detailProduct.data?.stok?[i].stok == null ||
                                  (detailProduct.data?.stok?[i].stok ?? 0) < 1
                              ? "Habis"
                              : "Tersedia",
                          style: poppins.copyWith(
                            color: detailProduct.data?.stok?[i].stok == null ||
                                    (detailProduct.data?.stok?[i].stok ?? 0) < 1
                                ? Colors.red
                                : backgroundColor3,
                            backgroundColor: detailProduct
                                            .data?.stok?[i].stok ==
                                        null ||
                                    (detailProduct.data?.stok?[i].stok ?? 0) < 1
                                ? Colors.red.withAlpha(40)
                                : backgroundColor3.withAlpha(40),
                          ),
                        ),
                        i != 0 || i != (detailProduct.data?.stok?.length ?? 0)
                            ? const SizedBox(
                                height: 30,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  },
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),

            // NOTE: Section 3: Detail Produk & Deskripsi Produk
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Produk",
                    style: poppins.copyWith(
                      fontWeight: semiBold,
                      fontSize: 16,
                      color: backgroundColor1,
                    ),
                  ),
                  productDetailsContent(
                      "Merk", "${detailProduct.data?.merkProduk}"),
                  productDetailsContent(
                      "Satuan", "${detailProduct.data?.satuanProduk}"),
                  productDetailsContent("Stok",
                      "${detailProduct.data?.stok?.firstWhere((element) => element.cabang?.toLowerCase() == widget.productLoct?.toLowerCase()).stok}"),
                  productDetailsContent(
                      "Kategori", "${detailProduct.data?.kat3}"),
                  Text(
                    "Deskripsi Produk",
                    style: poppins.copyWith(
                      fontWeight: semiBold,
                      fontSize: 16,
                      color: backgroundColor1,
                    ),
                  ),
                  ReadMoreText(
                    "${detailProduct.data?.deskripsiProduk}",
                    style: poppins.copyWith(
                      fontWeight: light,
                    ),
                    trimLines: 5,
                    colorClickableText: Colors.lightBlue,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '\nLebih banyak',
                    trimExpandedText: '\nLebih sedikit',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),

            // NOTE: Section 4: Ulasan
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ulasan",
                        style: poppins.copyWith(
                          fontWeight: semiBold,
                          fontSize: 16,
                          color: backgroundColor1,
                        ),
                      ),
                      (ulasanProduct.data?.length ?? 0) > 0
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const UlasanProductPage(),
                                      type: PageTransitionType.rightToLeft,
                                    ));
                              },
                              child: Text(
                                "LIhat Semua",
                                style: poppins.copyWith(
                                  color: backgroundColor3,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            if (ulasanProductIsLoading) ...{
              Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: backgroundColor1,
                  ),
                ),
              ),
            } else ...{
              if ((ulasanProduct.data ?? []).isEmpty) ...{
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Produk ini belum memiliki ulasan",
                      style: poppins,
                    ),
                  ),
                )
              } else ...{
                for (var i = 0;
                    i <
                        ((ulasanProduct.data?.length ?? 0) > 1
                            ? 1
                            : (ulasanProduct.data?.length ?? 0));
                    i++) ...{
                  productReviewContent(
                    namaPengguna: "${ulasanProduct.data?[i].namaPelanggan}",
                    rating: ulasanProduct.data?[i].rating ?? 0,
                    ulasan: ulasanProduct.data?[i].ulasan ?? "",
                    tanggalUlasan: ulasanProduct.data?[i].createdAt ?? "",
                  )
                }
              }
            },
          ],
        ),
      );
    }

    void sendProduct({
      required int cabangId,
      List<int>? multiSatuanJumlah,
      List<String>? multiSatuanunit,
      List<int>? jumlahMultiSatuan,
    }) async {
      setState(() {
        isLoading = true;
      });
      if (await cartProvider.postCart(
        token: loginProvider.loginModel.token ?? "",
        cabangId: cabangId,
        productId: detailProduct.data?.id ?? 0,
        multiSatuanJumlah: multiSatuanJumlah,
        multiSatuanunit: multiSatuanunit,
        jumlahMultiSatuan: jumlahMultiSatuan,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: backgroundColor1,
          content: Text(
            "produk ${detailProduct.data?.namaProduk} berhasil ditambahkan",
            style: poppins,
          ),
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          action: SnackBarAction(
            label: 'Lihat Keranjang',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: const CartPage(),
                      type: PageTransitionType.bottomToTop));
            },
          ),
        ));
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Gagal memasukkan produk kedalam keranjang",
            style: poppins,
          ),
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      }
    }

    void bottomDialog({required int cabangId}) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          var listMultisatuanUnit =
              "${detailProduct.data?.multisatuanUnit}".split("/");
          var listMultiSatuanJumlah =
              "${detailProduct.data?.multisatuanJumlah}".split("/");
          List<int> listJumlahMultiSatuan = [];
          for (var i = 0; i < (listMultisatuanUnit.length); i++) {
            listJumlahMultiSatuan.add(0);
          }
          if ((widget.jumlahMultiSatuan ?? []).isNotEmpty) {
            listJumlahMultiSatuan = widget.jumlahMultiSatuan ?? [];
          }

          var jumlahTotalBarang = 0;

          for (var i = 0; i < (listJumlahMultiSatuan.length); i++) {
            jumlahTotalBarang += listJumlahMultiSatuan[i] *
                int.parse((listMultiSatuanJumlah[i]));
          }

          // var golonganProduct = "${detailProduct.data?.golonganProduk}".split("/");

          return StatefulBuilder(builder: (BuildContext context,
              StateSetter stateSetter /*You can rename this!*/) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Satuan Produk",
                    style: poppins.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                      color: backgroundColor1,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        for (var i = 0;
                            i < (listMultisatuanUnit.length);
                            i++) ...{
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${listMultisatuanUnit[i]} (isi ${listMultiSatuanJumlah[i]})",
                                  style: poppins,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (listJumlahMultiSatuan[i] > 0) {
                                        stateSetter(() {
                                          listJumlahMultiSatuan[i] -= 1;
                                          jumlahTotalBarang -= (int.parse(
                                              listMultiSatuanJumlah[i]));
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: backgroundColor2,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      // "${product?.jumlah}",
                                      "${listJumlahMultiSatuan[i]}",
                                      style: poppins.copyWith(
                                        color: backgroundColor1,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      var cek =
                                          listJumlahMultiSatuan[i] + 1; // 1 2 3
                                      if (jumlahTotalBarang +
                                              int.parse(listMultiSatuanJumlah[
                                                  i]) <= // 1 12 34
                                          (detailProduct.data?.stok
                                                  ?.where((element) =>
                                                      element.cabang
                                                          ?.toLowerCase() ==
                                                      widget.productLoct
                                                          ?.toLowerCase())
                                                  .first
                                                  .stok ??
                                              0)) {
                                        stateSetter(() {
                                          listJumlahMultiSatuan[i] += 1;
                                          jumlahTotalBarang += (int.parse(
                                              listMultiSatuanJumlah[i]));
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: backgroundColor3,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        }
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        if (listJumlahMultiSatuan
                            .where((element) => element != 0)
                            .isNotEmpty) {
                          print(
                              "yang akan dikirim adalah: $listJumlahMultiSatuan dengan $listMultiSatuanJumlah dan $listMultisatuanUnit dan ${detailProduct.data?.golonganProduk}");
                          Navigator.pop(context);
                          sendProduct(
                            cabangId: cabangId,
                            jumlahMultiSatuan: listJumlahMultiSatuan,
                            multiSatuanJumlah: listMultiSatuanJumlah
                                .map((e) => int.parse(e))
                                .toList(),
                            multiSatuanunit: listMultisatuanUnit,
                          );
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Anda belum memilih jumlah produk",
                              style: poppins,
                            ),
                            duration: const Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ));
                        }
                        // sendProduct(cabangId: cabangId, jumlahMultiSatuan: listJumlahMultiSatuan);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: backgroundColor3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text(
                        "Konfirmasi",
                        style: poppins.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      );
    }

    Widget addToCartButton() {
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: TextButton(
            onPressed: () async {
              if ((detailProduct.data?.stok
                          ?.where((element) =>
                              element.cabang?.toLowerCase() ==
                              widget.productLoct?.toLowerCase())
                          .first
                          .stok ??
                      0) >=
                  1) {
                int? cabangId = detailProduct.data?.stok
                    ?.where((element) =>
                        element.cabang?.toLowerCase() ==
                        widget.productLoct?.toLowerCase())
                    .first
                    .cabangId;
                print("cabangId yang akan digunakan adalah: $cabangId");
                // CartModel
                if (detailProduct.data != null) {
                  if (detailProduct.data?.multisatuanJumlah != null &&
                      detailProduct.data?.multisatuanUnit != null) {
                    bottomDialog(cabangId: cabangId ?? 0);
                  } else {
                    // Jika multisatuan kosong
                    sendProduct(cabangId: cabangId ?? 0);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Gagal memasukkan produk kedalam keranjang",
                      style: poppins,
                    ),
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    "Barang ini habis",
                    style: poppins,
                  ),
                  duration: const Duration(seconds: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ));
              }
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
                  isLoading
                      ? const SizedBox()
                      : const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                  isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
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
        child: Column(
          children: [
            headerNavigation(),
            // NotificationListener<ScrollNotification>(
            //   onNotification: (ScrollNotification scrollInfo) {
            //     if (scrollInfo is ScrollUpdateNotification &&
            //         scrollInfo.metrics.axis == Axis.vertical) {
            //       setState(() {
            //         // Calculate the new alpha value based on scroll position
            //         double newAlpha = 0.0 +
            //             (scrollInfo.metrics.pixels /
            //                 scrollInfo.metrics.maxScrollExtent);

            //         if (newAlpha > 0.0) {
            //           newAlpha = 1;
            //         }
            //         // Limit alpha to be in the range [0, 1]
            //         headerAlpha = newAlpha.clamp(0.0, 1.0);
            //       });
            //     }
            //     return false;
            //   },
            //   child: ListView(
            //     children: [
            //       Stack(
            //         children: [
            //           header(),
            //           content(),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
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
