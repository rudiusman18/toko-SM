import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/product_model.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/product_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../product_detail/product_detail_page.dart';

// ignore: must_be_immutable
class ProductListSearchResult extends StatefulWidget {
  String searchKeyword;
  String sort;
  String category;
  String categoryToShow;
  ProductListSearchResult(
      {super.key,
      required this.searchKeyword,
      required this.sort,
      required this.category,
      required this.categoryToShow});

  @override
  State<ProductListSearchResult> createState() =>
      _ProductListSearchResultState();
}

class _ProductListSearchResultState extends State<ProductListSearchResult> {
  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();
  List<String> textSuggestion = [];
  List<String> textDatabase = [];
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  ProductModel productModel = ProductModel();
  ProductModel product = ProductModel(); // Hanya digunakan di initproduct
  int tagCounter = 0;

// Scroll Controller
  final scrollController = ScrollController();
  bool scrollIsAtEnd = false;
  int page = 1;
  bool productisReachEnd = false;

  @override
  void initState() {
    super.initState();
    searchTextFieldController.text = widget.searchKeyword;
    searchTextFieldFocusNode.addListener(_onFocusChange);
    scrollController.addListener(_scrollController);
    _initProduct();

    _initSuggestionText();
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

  _initProduct({String page = "1"}) async {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    if (await productProvider.getProduct(
        cabangId: "1",
        token: "${loginProvider.loginModel.token}",
        page: page,
        limit: "20",
        sort: widget.sort,
        category: widget.category,
        search: widget.searchKeyword)) {
      setState(() {
        if (widget.sort == "promo") {
          product = productProvider.promoProduct;
        } else if (widget.sort == "terlaris") {
          product = productProvider.palingLarisProduct;
        } else {
          product = productProvider.product;
        }
        print("isi product model yang dicari: ${product.message}");
      });

      if (page == "1" && product.data != null) {
        productModel = product;
      } else if (product.data?.isEmpty == false) {
        productisReachEnd = false;
        productModel.data?.addAll(product.data?.toList() ?? []);
      } else {
        setState(() {
          productisReachEnd = true;
        });
      }
    }
  }

  _scrollController() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrollIsAtEnd = true;
        if (productisReachEnd == false) {
          page += 1;
          _initProduct(page: page.toString());
        }
      });
    } else {
      setState(() {
        scrollIsAtEnd = false;
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
    Widget searchBar() {
      return Container(
        margin: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            searchTextFieldFocusNode.hasFocus
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                    ),
                  ),
            Flexible(
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
                  if (searchTextFieldController.text.isNotEmpty) {
                    print(
                        "object yang dicari adalah ${searchTextFieldController.text}");
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ProductListSearchResult(
                              searchKeyword: searchTextFieldController.text,
                              sort: widget.sort,
                              category: widget.category,
                              categoryToShow: widget.categoryToShow,
                            ),
                            type: PageTransitionType.fade));
                    setState(() {
                      searchTextFieldFocusNode.canRequestFocus = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "Cari Barang",
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
          ],
        ),
      );
    }

    Widget searchSuggestion({required List<String> text}) {
      print("panjang text nya adalah: ${text.length}");
      return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(
          top: 20,
        ),
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
                                    category: widget.category,
                                    sort: widget.sort,
                                    categoryToShow: widget.categoryToShow,
                                  ),
                                  type: PageTransitionType.fade));
                          setState(() {
                            searchTextFieldFocusNode.canRequestFocus = false;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
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

    Widget horizontalListItem({bool isOnDiscountContent = false}) {
      return (productModel.data ?? []).isEmpty
          ? Center(
              child: Text("hasil pencarian tidak ditemukan",
                  style: poppins.copyWith(color: backgroundColor1)))
          : SingleChildScrollView(
              controller: scrollController,
              child: Container(
                alignment: (productModel.data?.length ?? 0) > 1
                    ? Alignment.center
                    : Alignment.topLeft,
                margin: const EdgeInsets.only(
                  top: 0,
                  bottom: 30,
                  left: 20,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 20,
                      spacing: 10,
                      children: [
                        for (var i = 0;
                            i < (productModel.data?.length ?? 0);
                            i++)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ProductDetailPage(
                                    imageURL:
                                        "${productModel.data?[i].gambar?.first}",
                                    productId: "${productModel.data?[i].id}",
                                    productLoct: "Pusat",
                                    productName:
                                        "${productModel.data?[i].namaProduk}",
                                    productPrice:
                                        "${productModel.data?[i].hargaDiskon}",
                                    productStar:
                                        "${productModel.data?[i].rating}",
                                    beforeDiscountPrice: isOnDiscountContent
                                        ? "${productModel.data?[i].harga}"
                                        : null,
                                    discountPercentage: isOnDiscountContent
                                        ? "${productModel.data?[i].diskon}%"
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
                                    offset:
                                        const Offset(0, 8), // Shadow position
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
                                      ('${productModel.data?[i].gambar?.first}'),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "${productModel.data?[i].namaProduk}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: poppins.copyWith(
                                              color: backgroundColor1,
                                              fontWeight: medium,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "Rp ${currencyFormatter.format(productModel.data?[i].hargaDiskon)}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: poppins.copyWith(
                                              color: backgroundColor1,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                        ),
                                        if (productModel.data?[i].diskon !=
                                            null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "Rp ${currencyFormatter.format(productModel.data?[i].harga)}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: poppins.copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.grey,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  child: Text(
                                                    "${productModel.data?[i].diskon}%",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: backgroundColor2,
                                            ),
                                            Text(
                                              "${productModel.data?[i].rating}",
                                              style: poppins.copyWith(
                                                fontWeight: semiBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.location_city,
                                              color: backgroundColor2,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Cabang Pusat",
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
                    scrollIsAtEnd == true && productisReachEnd == false
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 20,
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
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
    }

    Widget horizontalTag({required String text, required String variable}) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor3,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: poppins.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            searchTextFieldFocusNode.hasFocus
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              if (widget.category.isNotEmpty) ...{
                                horizontalTag(
                                  text: widget.categoryToShow,
                                  variable: "category",
                                )
                              },
                              if (widget.sort.isNotEmpty) ...{
                                horizontalTag(
                                  text: widget.sort,
                                  variable: "sort",
                                )
                              }
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: widget.searchKeyword.isEmpty
                            ? const SizedBox()
                            : RichText(
                                text: TextSpan(
                                  text: 'Hasil Pencarian : ',
                                  style: poppins.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: widget.searchKeyword,
                                        style: poppins.copyWith(
                                          fontSize: 18,
                                          fontWeight: semiBold,
                                          color: backgroundColor3,
                                        )),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
            Expanded(
              child: searchTextFieldFocusNode.hasFocus
                  ? searchSuggestion(text: textSuggestion)
                  : horizontalListItem(),
            ),
          ],
        ),
      ),
    );
  }
}
