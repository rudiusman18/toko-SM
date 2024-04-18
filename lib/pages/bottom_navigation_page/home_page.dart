import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/home_page/product_list_search_result.dart';
import 'package:tokoSM/pages/bottom_navigation_page/product_detail/product_detail_page.dart';
import 'package:tokoSM/pages/profile_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../providers/page_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> adsBannerList = [];

  List<String> textSuggestion = [];
  List<String> textDatabase = [];

  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();

  // Keyboard
  bool keyboardIsVisible = false;

  int carouselIndex = 0;
  int productIndex = 0;

  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  // Banner Product
  bool bannerisLoading = false;

  // Promo Product
  bool promoIsLoading = false;
  ProductModel promoProduct = ProductModel();

  // Paling Laris Product
  bool palingLarisLoading = false;
  ProductModel palingLarisProduct = ProductModel();

  // scroll controller
  final scrollController = ScrollController();
  bool scrollIsAtEnd = false;
  int page = 1;
  bool palingLarisProductisReachEnd = false;

  @override
  void initState() {
    super.initState();
    searchTextFieldFocusNode.addListener(_onFocusChange);
    scrollController.addListener(_scrollController);
    _initBannerProduct();
    _initPromoProduct();
    _initPalingLarisProduct();
    _initSuggestionText();
  }

  _scrollController() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrollIsAtEnd = true;
        if (palingLarisProductisReachEnd == false) {
          page += 1;
          _initPalingLarisProduct(page: page.toString());
        }
      });
    } else {
      setState(() {
        scrollIsAtEnd = false;
      });
    }
  }

  _initSuggestionText() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (await productProvider.getSuggestion(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        textDatabase = productProvider.suggestionModel.data ?? [];
        print(
            "data suggestion adalah: ${textDatabase} dengan isi data ${productProvider.suggestionModel.data!}");
      });
    } else {
      print("data suggestion mengalami kegagalan");
    }
  }

  _initBannerProduct() async {
    //  Mendapatkan data banner produk
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      bannerisLoading = true;
    });

    if (await productProvider.getBannerProduct(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        bannerisLoading = false;
        adsBannerList = (productProvider.bannerProduct['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        bannerisLoading = false;
      });
    }
  }

  _initPromoProduct() async {
    // Mendapatkan data produk
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    setState(() {
      promoIsLoading = true;
      print(
          "cabang yang diakses adalah: ${"${loginProvider.loginModel.data?.cabangId}"}");
    });
    if (await productProvider.getProduct(
      cabangId: "${loginProvider.loginModel.data?.cabangId ?? 1}",
      token: loginProvider.loginModel.token ?? "",
      page: "1",
      limit: "5",
      sort: "promo",
    )) {
      setState(() {
        promoIsLoading = false;
        promoProduct = productProvider.promoProduct;
      });
    } else {
      setState(() {
        promoIsLoading = false;
      });
    }
  }

  _initPalingLarisProduct({String page = '1'}) async {
    // Mendapatkan data produk
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    setState(() {
      palingLarisLoading = true;
    });
    if (await productProvider.getProduct(
      cabangId: "${loginProvider.loginModel.data?.cabangId ?? 1}",
      token: loginProvider.loginModel.token ?? "",
      page: page,
      limit: "5",
      sort: "terlaris",
    )) {
      setState(() {
        palingLarisLoading = false;
        if (page == "1" && productProvider.palingLarisProduct.data != null) {
          palingLarisProductisReachEnd = false;
          palingLarisProduct = productProvider.palingLarisProduct;
        } else if (productProvider.palingLarisProduct.data?.isEmpty == false) {
          palingLarisProductisReachEnd = false;
          palingLarisProduct.data
              ?.addAll(productProvider.palingLarisProduct.data?.toList() ?? []);
        } else {
          setState(() {
            palingLarisProductisReachEnd = true;
          });
        }
      });
    } else {
      setState(() {
        palingLarisLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchTextFieldFocusNode.removeListener(_onFocusChange);
    searchTextFieldFocusNode.dispose();
  }

  void _onFocusChange() {
    setState(() {
      debugPrint("Focus: ${searchTextFieldFocusNode.hasFocus.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

//  Fungsi untuk membuat title text
    Widget titleText(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: poppins.copyWith(
            color: backgroundColor1,
            fontWeight: semiBold,
            fontSize: 24,
          ),
        ),
      );
    }

    Widget searchBar() {
      return Container(
        margin: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    print("search object: ${searchTextFieldController.text}");
                    textSuggestion.clear();
                    textSuggestion = textDatabase
                        .where((element) =>
                            element.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                    print("isi listnya adalah $textSuggestion");
                  });
                },
                textInputAction: TextInputAction.search,
                controller: searchTextFieldController,
                cursorColor: backgroundColor1,
                focusNode: searchTextFieldFocusNode,
                onFieldSubmitted: (_) {
                  print(
                      "object yang dicari adalah ${searchTextFieldController.text}");
                  if (searchTextFieldController.text.isNotEmpty) {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ProductListSearchResult(
                              searchKeyword: searchTextFieldController.text,
                              sort: "promo",
                              category: "",
                              categoryToShow: "",
                            ),
                            type: PageTransitionType.fade));
                    setState(() {
                      searchTextFieldController.text = "";
                      searchTextFieldFocusNode.canRequestFocus = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "Cari Barang",
                  hintStyle: poppins,
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchTextFieldFocusNode.hasFocus
                      ? backgroundColor1
                      : Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundColor1, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const ProfilePage(),
                          type: PageTransitionType.rightToLeft));
                },
                child: Icon(
                  Icons.view_list,
                  size: 30,
                  color: backgroundColor3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget searchSuggestion({required List<String> text}) {
      print("panjang text nya adalah: ${text.length}");
      return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: searchTextFieldController.text == ""
            ? const SizedBox()
            : ListView(
                children: [
                  for (var index = 0; index < text.length; index++)
                    InkWell(
                      onTap: () {
                        print("clicked on ${text[index]}");
                        if (searchTextFieldController.text.isNotEmpty) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ProductListSearchResult(
                                    searchKeyword: text[index],
                                    category: "",
                                    sort: "",
                                    categoryToShow: "",
                                  ),
                                  type: PageTransitionType.fade));
                          setState(() {
                            searchTextFieldController.text = "";
                            searchTextFieldFocusNode.canRequestFocus = false;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: backgroundColor1,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  text[index],
                                  style: poppins.copyWith(
                                    color: backgroundColor1,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.call_made,
                                  color: backgroundColor1,
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: backgroundColor1,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      );
    }

    Widget carouselSlider() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 8), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              CarouselSlider(
                  items: [
                    for (var img in adsBannerList)
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor2,
                          // borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(img['gambar_promo']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                  options: CarouselOptions(
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      padEnds: false,
                      viewportFraction: 1,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.linear,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          carouselIndex = index;
                        });
                      })),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: AnimatedSmoothIndicator(
                  activeIndex: carouselIndex,
                  count: adsBannerList.length,
                  effect: WormEffect(
                    activeDotColor: backgroundColor1,
                    dotColor: Colors.white,
                    dotWidth: 10,
                    dotHeight: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget horizontalListItem({bool isOnDiscountContent = false}) {
      var numberofItem = promoProduct.data?.length ?? 0;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var i = 0; i < numberofItem; i++)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ProductDetailPage(
                          imageURL: "${promoProduct.data?[i].gambar?.first}",
                          productId: "${promoProduct.data?[i].id}",
                          productLoct:
                              loginProvider.loginModel.data?.namaCabang ?? "",
                          productName: "${promoProduct.data?[i].namaProduk}",
                          productPrice: "${promoProduct.data?[i].hargaDiskon}",
                          productStar: "${promoProduct.data?[i].rating}",
                          beforeDiscountPrice: isOnDiscountContent
                              ? "${promoProduct.data?[i].harga}"
                              : null,
                          discountPercentage: isOnDiscountContent
                              ? "${promoProduct.data?[i].diskon}%"
                              : null,
                          isDiscount: isOnDiscountContent,
                        ),
                        type: PageTransitionType.bottomToTop,
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 8), // Shadow position
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(right: i < 19 ? 10 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: Image.network(
                            ('${promoProduct.data?[i].gambar?.first}'),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "${promoProduct.data?[i].namaProduk}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: poppins.copyWith(
                                    color: backgroundColor1,
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Rp ${currencyFormatter.format(promoProduct.data?[i].hargaDiskon)}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: poppins.copyWith(
                                    color: backgroundColor1,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                              if (isOnDiscountContent == true)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Rp ${currencyFormatter.format(promoProduct.data?[i].harga)}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: poppins.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                              fontSize: 10),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          "${promoProduct.data?[i].diskon}%",
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: backgroundColor2,
                                  ),
                                  Text(
                                    "${promoProduct.data?[i].rating}",
                                    style: poppins.copyWith(
                                      fontWeight: semiBold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: backgroundColor2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Cabang ${loginProvider.loginModel.data?.namaCabang ?? ""}",
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              numberofItem < 5
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ProductListSearchResult(
                                  searchKeyword: "",
                                  sort: "promo",
                                  category: "",
                                  categoryToShow: "",
                                ),
                                type: PageTransitionType.fade));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 300,
                        child: Text(
                          'Lihat Selengkapnya',
                          style: poppins.copyWith(
                            fontSize: 18,
                            fontWeight: medium,
                            color: backgroundColor1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    }

    Widget verticalListItem(int i) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: ProductDetailPage(
                productId: "${(palingLarisProduct.data?[i].id ?? 0)}",
                imageURL: palingLarisProduct.data?[i].gambar?.first,
                productLoct: loginProvider.loginModel.data?.namaCabang ?? "",
                discountPercentage: palingLarisProduct.data?[i].diskon == null
                    ? ""
                    : "${palingLarisProduct.data?[i].diskon}%",
                beforeDiscountPrice: palingLarisProduct.data?[i].diskon == null
                    ? ""
                    : "${palingLarisProduct.data?[i].harga}",
                productName: palingLarisProduct.data?[i].namaProduk,
                productPrice: palingLarisProduct.data?[i].diskon == null
                    ? "${palingLarisProduct.data?[i].harga}"
                    : palingLarisProduct.data?[i].hargaDiskon.toString(),
                productStar: palingLarisProduct.data?[i].rating.toString(),
                isDiscount:
                    palingLarisProduct.data?[i].diskon == null ? false : true,
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
                  "${palingLarisProduct.data?[i].gambar?.first}",
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
                        "${palingLarisProduct.data?[i].namaProduk}",
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
                        palingLarisProduct.data?[i].diskon == null
                            ? "Rp ${currencyFormatter.format(palingLarisProduct.data?[i].harga)}"
                            : "Rp ${currencyFormatter.format(palingLarisProduct.data?[i].hargaDiskon)}",
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
                            "${palingLarisProduct.data?[i].rating}",
                            style: poppins.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (palingLarisProduct.data?[i].diskon == null
                        ? false
                        : true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "Rp ${currencyFormatter.format(palingLarisProduct.data?[i].harga)}",
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
                                "${palingLarisProduct.data?[i].diskon}%",
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
                              "Cabang ${loginProvider.loginModel.data?.namaCabang ?? ""}",
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
      );
    }

    Widget homePageContent() {
      return SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carouselSlider(),
            const SizedBox(
              height: 20,
            ),
            titleText("Sedang Promo"),
            horizontalListItem(isOnDiscountContent: true),
            const SizedBox(
              height: 20,
            ),
            titleText("Paling Laris"),
            const SizedBox(
              height: 5,
            ),
            for (int i = 0; i < (palingLarisProduct.data?.length ?? 0); i++)
              verticalListItem(i),
            scrollIsAtEnd == true && palingLarisProductisReachEnd == false
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: backgroundColor1,
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              searchBar(),
              Expanded(
                child: searchTextFieldFocusNode.hasFocus
                    ? searchSuggestion(text: textSuggestion)
                    : homePageContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
