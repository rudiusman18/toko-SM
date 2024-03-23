import 'dart:ffi';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/home_page/product_list_search_result.dart';
import 'package:tokoSM/pages/bottom_navigation_page/product_detail/product_detail_page.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/pages/profile_page.dart';
import 'package:tokoSM/providers/login_provider.dart';
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
  final List<String> adsBannerList = [
    "https://lelogama.go-jek.com/post_featured_image/promo-kesebelasan-Anniv_GoFood_Blog-Banner_1456x818_200rb.jpg",
    "https://lelogama.go-jek.com/post_thumbnail/promo-go-food-des-2022.jpg",
    "https://bankmega.com/media/filer_public/73/01/73017ae3-22cb-487e-8f55-6a7817730adb/0-banner-bm-new-eos-tfi.jpg",
    "https://shopee.co.id/inspirasi-shopee/wp-content/uploads/2020/05/Banner-15-Mei_Horizontal.jpg",
    "https://bankmega.com/media/filer_public/a0/c1/a0c12e79-f551-478d-a5cf-e0815d0e4028/0-bm-banner-ecommerce-payday.jpg"
  ];
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1519420573924-65fcd45245f8?auto=format&fit=crop&q=80&w=1935&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591184510259-b6f1be3d7aff?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1472141521881-95d0e87e2e39?auto=format&fit=crop&q=80&w=2072&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1611945007935-925b09ddcf1b?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591184510259-b6f1be3d7aff?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1591254460606-fab865bf82b8?auto=format&fit=crop&q=80&w=1932&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];

  List<String> textSuggestion = [];
  List<String> dummyTextDatabase = [
    "sambal",
    "Kecap",
    "saos",
    "coca-cola",
    "meses",
    "shampo",
    "sabun"
  ];

  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();

  // Keyboard
  bool keyboardIsVisible = false;

  int carouselIndex = 0;
  int productIndex = 0;

  @override
  void initState() {
    super.initState();
    searchTextFieldFocusNode.addListener(_onFocusChange);
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
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    LoginModel userLogin = loginProvider.loginModel;

    Widget header() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  pageProvider.currentIndex = 1;
                });
              },
              child: Icon(
                Icons.view_list,
                size: 30,
                color: backgroundColor3,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "${userLogin.data?.namaPelanggan}",
                    style: poppins.copyWith(
                      fontWeight: semiBold,
                      color: backgroundColor1,
                    ),
                  ),
                  Text(
                    "${userLogin.data?.alamatPelanggan}",
                    style: poppins.copyWith(
                      fontWeight: medium,
                      color: backgroundColor2,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const ProfilePage(),
                        type: PageTransitionType.rightToLeft));
              },
              child: Icon(
                Icons.person,
                size: 30,
                color: backgroundColor3,
              ),
            ),
          ],
        ),
      );
    }

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
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              print("search object: ${searchTextFieldController.text}");
              textSuggestion.clear();
              textSuggestion = dummyTextDatabase
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
                          searchKeyword: searchTextFieldController.text),
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
                                      searchKeyword: text[index]),
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
                            image: NetworkImage(img),
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
                    activeDotColor: backgroundColor2,
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
      List<String> listImageData = [];
      for (var i = 0; i < 20; i++) {
        // var imageData = (imgList..shuffle()).first;
        // listImageData.add(imageData);
        productIndex = (productIndex + 1);
        if (productIndex == imgList.length - 1) {
          productIndex = 0;
          listImageData.add(imgList[productIndex]);
        } else {
          listImageData.add(imgList[productIndex]);
        }
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              for (var i = 0; i < 20; i++)
                InkWell(
                  onTap: () {
                    print("ditekan untuk object foto: $i");
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ProductDetailPage(
                          imageURL: listImageData[i],
                          productLoct: "Cabang Malang Kota",
                          productName: "Lorem Ipsum dolor sit amet",
                          productPrice: "Rp 18.000,00",
                          productStar: "4.5",
                          beforeDiscountPrice:
                              isOnDiscountContent ? "Rp 180.000,00" : null,
                          discountPercentage:
                              isOnDiscountContent ? "50%" : null,
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
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: Image.network(
                            (listImageData[i]),
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
                                  "Lorem Ipsum dolor sit amet",
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
                                  "Rp 18.000,00",
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
                                          "Rp 180.000,00",
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
                              Row(
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    Widget verticalListItem(String imageUrl,
        {bool isOnDiscountContent = false}) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: ProductDetailPage(
                imageURL: imageUrl,
                productLoct: "Cabang Malang Kota",
                productName: "Lorem Ipsum dolor sit amet",
                productPrice: "Rp 18.000,00",
                productStar: "4.5",
                isDiscount: isOnDiscountContent,
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
                color: Colors.grey.withOpacity(0.2),
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
                        "Lorem Ipsum Dolor sit Amet",
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
                        "Rp 18.000,00",
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
                            "4.5",
                            style: poppins.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isOnDiscountContent == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "Rp 180.000,00",
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
            ],
          ),
        ),
      );
    }

    Widget homePageContent() {
      return ListView(
        children: [
          carouselSlider(),
          const SizedBox(
            height: 20,
          ),
          titleText("Barang Populer"),
          horizontalListItem(),
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
          for (var data in imgList) verticalListItem(data),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              header(),
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
