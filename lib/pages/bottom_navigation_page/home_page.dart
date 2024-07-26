import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokoSM/models/cabang_model.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/home_page/product_list_search_result.dart';
import 'package:tokoSM/pages/bottom_navigation_page/product_detail/product_detail_page.dart';
import 'package:tokoSM/pages/main_page.dart';
import 'package:tokoSM/pages/profile_page.dart';
import 'package:tokoSM/providers/cabang_provider.dart';
import 'package:tokoSM/providers/cart_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<Map<String, dynamic>> adsBannerList = [];

  List<String> textSuggestion = [];
  List<String> textDatabase = [];

  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();

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
  var totalProductInCart = 0;

  Map<String, dynamic> cabangTerpilih = {};
  CabangModel cabangModel = CabangModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    searchTextFieldFocusNode.addListener(_onFocusChange);
    scrollController.addListener(_scrollController);
    _initBannerProduct();
    _initPromoProduct();
    _initPalingLarisProduct();
    _initSuggestionText();
    _initCartProduct();
  }

  // current location
  late Position _currentPosition;
  bool _resumed = false; // Flag to check if app is already resumed

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_resumed) {
      setState(() {
        _resumed = true;
      });
    } else if (state == AppLifecycleState.paused) {
      // Reset _resumed flag when app goes to the background
      setState(() {
        _resumed = false;
      });
    }
  }

  _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedForeverDialog();
    } else {
      _requestPermission();
    }
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.denied) {
      _showPermissionDeniedForeverDialog();
    } else if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showPermissionDeniedForeverDialog();
    }
  }

  _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "Butuh Perizinan Lokasi",
          style: poppins,
        ),
        content: Text(
          "Aplikasi ini membutuhkan perizinan lokasi anda untuk menentukan lokasi cabang terdekat toko kami. Mohon untuk mengatur perizinan lokasi di pengaturan",
          style: poppins,
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              "BATAL",
              style: poppins,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const MainPage(),
                          type: PageTransitionType.fade))
                  .then((value) => setState(() {}));
            },
          ),
          ElevatedButton(
            child: const Text("BUKA PENGATURAN"),
            onPressed: () {
              setState(() {
                _resumed = false;
              });
              openAppSettings();
              Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const MainPage(),
                          type: PageTransitionType.fade))
                  .then((value) => setState(() {}));
            },
          ),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      print("current Location: ${_currentPosition}");
      _initDataCabang();
    });
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

  _initDataCabang() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    CabangProvider cabangProvider =
        Provider.of<CabangProvider>(context, listen: false);
    if (await cabangProvider.postLatLonToGetDataCabang(
        token: loginProvider.loginModel.token ?? "",
        lat: "${_currentPosition.latitude}",
        lon: "${_currentPosition.longitude}")) {
      cabangModel = cabangProvider.cabangModel;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(
        "isi dari cabang terpilih adalah: ${prefs.getString("cabangterpilih") ?? ""}");

    if (prefs.getString("cabangterpilih") != null) {
      cabangTerpilih = jsonDecode(prefs.getString("cabangterpilih") ?? "");
    }
  }

  _initCartProduct() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    if (await cartProvider.getCart(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        var jumlah = 0;
        for (var i = 0; i < (cartProvider.cartModel.data?.length ?? 0); i++) {
          setState(() {
            jumlah += cartProvider.cartModel.data?[i].data?.length ?? 0;
          });
        }
        setState(() {
          totalProductInCart = jumlah;
        });
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
      cabangId:
          "${cabangTerpilih["id"] ?? loginProvider.loginModel.data?.cabangId}",
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
      cabangId:
          "${cabangTerpilih["id"] ?? loginProvider.loginModel.data?.cabangId}",
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

    WidgetsBinding.instance.removeObserver(this);
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

    Widget header() {
      return Container(
        margin: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: (cabangModel.data ?? []).isEmpty
                      ? const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 16,
                              color: backgroundColor2,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                cabangTerpilih['nama_cabang'] == null
                                    ? '${cabangModel.data?.first.namaCabang}'
                                    : '${cabangTerpilih['nama_cabang']}',
                                style: poppins.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: backgroundColor2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                  items: (cabangModel.data ?? [])
                      .map(
                        (DataCabang item) => DropdownMenuItem<String>(
                          value: jsonEncode(item.toJson()),
                          child: Text(
                            "${item.namaCabang ?? ""} ${item.terdekat ?? false ? "(Terdekat)" : ""}",
                            style: poppins,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      cabangTerpilih = jsonDecode(value ?? "");
                    });
                    var data = DataCabang.fromJson(cabangTerpilih);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("cabangterpilih", jsonEncode(data));
                    _checkPermission();
                    _initBannerProduct();
                    _initPromoProduct();
                    _initPalingLarisProduct();
                    _initSuggestionText();
                    _initCartProduct();
                  },
                  iconStyleData: IconStyleData(
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: backgroundColor2,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    offset: const Offset(-20, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              PageTransition(
                                  child: const CartPage(),
                                  type: PageTransitionType.rightToLeft))
                          .then((value) {
                        _checkPermission();
                        _initBannerProduct();
                        _initPromoProduct();
                        _initPalingLarisProduct();
                        _initSuggestionText();
                        _initCartProduct();
                      });
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: backgroundColor3,
                          ),
                        ),
                        totalProductInCart == 0
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "$totalProductInCart",
                                    style: poppins.copyWith(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                      ],
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
                                  type: PageTransitionType.rightToLeft))
                          .then((value) {
                        _checkPermission();
                        _initBannerProduct();
                        _initPromoProduct();
                        _initPalingLarisProduct();
                        _initSuggestionText();
                        _initCartProduct();
                      });
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
          ],
        ),
      );
    }

    Widget searchBar() {
      return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
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
                      child: ProductListSearchResultPage(
                        searchKeyword: searchTextFieldController.text,
                        sort: "",
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
                                  child: ProductListSearchResultPage(
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
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    text[index],
                                    style: poppins.copyWith(
                                      color: backgroundColor1,
                                    ),
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
                          cabangId:
                              "${cabangTerpilih["id"] ?? loginProvider.loginModel.data?.cabangId}",
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
                    height: 280,
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
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: [
                              //     Icon(
                              //       Icons.location_city,
                              //       color: backgroundColor2,
                              //     ),
                              //     Expanded(
                              //       child: Text(
                              //         "Cabang ${loginProvider.loginModel.data?.namaCabang ?? ""}",
                              //         overflow: TextOverflow.ellipsis,
                              //         maxLines: 1,
                              //         style: poppins.copyWith(
                              //           color: backgroundColor2,
                              //           fontWeight: medium,
                              //           fontSize: 12,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // )
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
                                child: ProductListSearchResultPage(
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

    Widget palingLarisItem() {
      return Container(
        alignment: (palingLarisProduct.data?.length ?? 0) > 1
            ? Alignment.center
            : Alignment.topLeft,
        margin: const EdgeInsets.only(
          top: 0,
          bottom: 30,
          left: 20,
          right: 10,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 20,
          spacing: 10,
          children: [
            for (var i = 0; i < (palingLarisProduct.data?.length ?? 0); i++)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductDetailPage(
                        imageURL:
                            "${palingLarisProduct.data?[i].gambar?.first}",
                        productId: "${palingLarisProduct.data?[i].id}",
                        cabangId:
                            "${cabangTerpilih["id"] ?? loginProvider.loginModel.data?.cabangId}",
                        productLoct:
                            loginProvider.loginModel.data?.namaCabang ?? "",
                        productName:
                            "${palingLarisProduct.data?[i].namaProduk}",
                        productPrice:
                            "${palingLarisProduct.data?[i].hargaDiskon}",
                        productStar: "${palingLarisProduct.data?[i].rating}",
                        beforeDiscountPrice:
                            palingLarisProduct.data?[i].diskon == null
                                ? ""
                                : "${palingLarisProduct.data?[i].harga}",
                        discountPercentage:
                            palingLarisProduct.data?[i].diskon == null
                                ? ""
                                : "${palingLarisProduct.data?[i].diskon}%",
                        isDiscount: palingLarisProduct.data?[i].diskon == null
                            ? false
                            : true,
                      ),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  height: 280,
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
                          ('${palingLarisProduct.data?[i].gambar?.first}'),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Rp ${currencyFormatter.format(palingLarisProduct.data?[i].hargaDiskon)}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: poppins.copyWith(
                                  color: backgroundColor1,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ),
                            if (palingLarisProduct.data?[i].diskon != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Rp ${currencyFormatter.format(palingLarisProduct.data?[i].harga)}",
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
                            Row(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget homePageContent() {
      return RefreshIndicator(
        onRefresh: () async {
          _checkPermission();
          _initBannerProduct();
          _initPromoProduct();
          _initPalingLarisProduct();
          _initSuggestionText();
          _initCartProduct();
        },
        color: backgroundColor1,
        child: SingleChildScrollView(
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
              // for (int i = 0; i < (palingLarisProduct.data?.length ?? 0); i++)
              palingLarisItem(),
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
        ),
      );
    }

    return KeyboardVisibilityBuilder(
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      builder: (BuildContext, bool isKeyboardVisible) {
        print("kondisi keyboard: $isKeyboardVisible");
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
                    child: isKeyboardVisible
                        ? searchSuggestion(text: textSuggestion)
                        : homePageContent(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
