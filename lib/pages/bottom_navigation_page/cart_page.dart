// ignore_for_file: avoid_print

import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/login_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page/delivery_page.dart';
import 'package:tokoSM/pages/bottom_navigation_page/product_detail/product_detail_page.dart';
import 'package:tokoSM/providers/cart_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartModel cartModel = CartModel();
  int indexCabang = 0;

  LoginModel loginmodel = LoginModel();
  List<String> listCabang = [];

  TextEditingController catatantextField = TextEditingController(text: "");

  // CheckBox
  List<bool> isChecked = [];

  int subTotalHarga = 0;
  int totalHarga = 0;

  CartModel deliveryProduct = CartModel();

  @override
  void initState() {
    super.initState();
    print("init dijalankan");
    _initCartProduct();
  }

  _initCartProduct() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    if (await cartProvider.getCart(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        // Ensure indexCabang is within bounds
        indexCabang = indexCabang < 0 ? 0 : indexCabang;
        final int maxIndex = (cartModel.data?.length ?? 1) - 1;
        indexCabang = indexCabang > maxIndex ? maxIndex : indexCabang;

// Print indexCabang and maxIndex for debugging
        print("indexCabang: $indexCabang, maxIndex: $maxIndex");

// Update cartModel with the latest data from cartProvider
        cartModel = cartProvider.cartModel;

// Update deliveryProduct with the updated cartModel
        deliveryProduct = CartModel.fromJson(cartModel.toJson());

// Update listCabang with the latest data from cartProvider
        listCabang = cartProvider.cartModel.data
                ?.map((e) => e.namaCabang ?? "")
                .toList() ??
            [];

// Ensure that indexCabang is within bounds after updating cartModel
        indexCabang = indexCabang < 0 ? 0 : indexCabang;
        final int updatedMaxIndex = (cartModel.data?.length ?? 1) - 1;
        indexCabang =
            indexCabang > updatedMaxIndex ? updatedMaxIndex : indexCabang;

// Print updated indexCabang and updated maxIndex for debugging
        print(
            "Updated indexCabang: $indexCabang, Updated maxIndex: $updatedMaxIndex");

        print(
            // ignore: unnecessary_brace_in_string_interps
            "indexCabang saat ini adalah ${indexCabang > ((cartModel.data?.length ?? 1) - 1) ? ((cartModel.data?.length ?? 1) - 1) : indexCabang} ${(cartModel.data?.length ?? 1) - 1} ${indexCabang} dengan jumlah isChecked ${isChecked.length}");

        subTotalHarga = 0;
        if (cartModel.data?.isNotEmpty ?? false) {
          for (var i = 0;
              i < (cartModel.data?[indexCabang].data?.length ?? 0);
              i++) {
            if (isChecked.length <
                (cartModel.data?[indexCabang].data?.length ?? 0)) {
              isChecked.add(true); // menambahkan data true untuk list checkbox
            }
            isChecked[i] = true;

            if (isChecked[i] == true) {
              var product = cartModel.data?[indexCabang].data?[i];
              String? numericString =
                  "${product?.diskon != null ? product?.hargaDiskon : product?.harga ?? 0}";
              int numericValue =
                  int.parse(numericString); // Parses the string as an integer
              subTotalHarga += numericValue * (product?.jumlah ?? 0);
            }
          }
        }

        loginmodel = loginProvider.loginModel;
        print(
            "isi loginModel adalah: ${loginmodel.data?.namaCabang} dengan index: $indexCabang dengan ${(cartModel.data?.length)}");
      });
    }
  }

  _updateCartProduct({
    required String cuid,
    required String jumlah,
  }) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    if (await cartProvider.updateCart(
      token: loginProvider.loginModel.token ?? "",
      productId: cuid,
      jumlah: jumlah,
    )) {
      setState(() {
        _initCartProduct();
      });
    }
  }

  _deleteCartProduct({
    required String cuid,
  }) async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    if (await cartProvider.deleteCart(
      token: loginProvider.loginModel.token ?? "",
      productId: cuid,
    )) {
      setState(() {
        _initCartProduct();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    final currencyFormatter = NumberFormat('#,##0.00', 'ID');

    void showAlertDialog(BuildContext context, DataKeranjang? product) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "Warning!",
                  style: poppins.copyWith(
                    color: backgroundColor1,
                    fontWeight: semiBold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 1,
                  color: backgroundColor1,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            content: Text(
              "Anda yakin untuk menghapus ${product?.namaProduk} dari keranjang?",
              style: poppins.copyWith(color: backgroundColor1),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Batal",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: backgroundColor1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _deleteCartProduct(cuid: "${product?.sId}");
                    // productProvider.cartData.removeWhere((element) =>
                    //     element.product!.urlImg == product.product!.urlImg);
                  });
                },
                child: Text(
                  "Lanjutkan",
                  style: poppins.copyWith(
                    fontWeight: semiBold,
                    color: backgroundColor1,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    Widget customtextFormField({
      required TextInputType keyboardType,
      required TextEditingController controller,
    }) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          textInputAction: TextInputAction.newline,
          maxLines: 4,
          style: poppins.copyWith(
            color: backgroundColor1,
          ),
          keyboardType: keyboardType,
          cursorColor: backgroundColor1,
          controller: controller,
          decoration: InputDecoration(
            hintText: "...",
            hintStyle: poppins.copyWith(
              color: backgroundColor1,
            ),
            prefixIconColor: Colors.grey,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget showCatatanProduct({
      required DataKeranjang product,
    }) {
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, stateSetter) {
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Catatan Produk",
                    style: poppins.copyWith(
                      fontWeight: semiBold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://tokosm.online/uploads/images/${product.imageUrl}"))),
                      ),
                      Expanded(
                        child: Text(
                          "${product.namaProduk}",
                          style: poppins.copyWith(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  customtextFormField(
                    controller: catatantextField,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () async {
                        stateSetter(() {
                          isLoading = true;
                        });
                        await cartProvider.updateCatatanCart(
                          token: loginmodel.token ?? "",
                          productId: "${product.sId}",
                          catatan: catatantextField.text,
                        );
                        stateSetter(() {
                          _initCartProduct();
                          isLoading = false;
                          Navigator.pop(context);
                        });
                      },
                      child: isLoading
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Simpan",
                              style: poppins,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget cartItem({required int index}) {
      var product = cartModel.data?[indexCabang].data?[index];
      String? numericString =
          "${product?.diskon != null ? product?.hargaDiskon : product?.harga ?? 0}";
      int numericValue =
          int.parse(numericString); // Parses the string as an integer

      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: ProductDetailPage(
                imageURL:
                    "https://tokosm.online/uploads/images/${product?.imageUrl}",
                productId: "${product?.produkId}",
                productLoct: "${cartModel.data?[indexCabang].namaCabang}",
                productName: "${product?.namaProduk}",
                productPrice: "${product?.hargaDiskon}",
                productStar: "0.0", //"${product?.}",
                beforeDiscountPrice:
                    product?.diskon == null ? "" : "${product?.harga}",
                discountPercentage:
                    product?.diskon == null ? "" : "${product?.diskon}%",
                isDiscount: product?.diskon == null ? false : true,
              ),
              type: PageTransitionType.bottomToTop,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          padding: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 8), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                activeColor: backgroundColor1,
                value: isChecked[index],
                onChanged: (value) {
                  print("isi value adalah: $value");
                  setState(() {
                    isChecked[index] = value ?? true;
                  });
                  if (isChecked[index] == false) {
                    setState(() {
                      subTotalHarga -= numericValue * (product?.jumlah ?? 0);
                      deliveryProduct.data?[indexCabang].data?.removeWhere(
                          (element) =>
                              element.namaProduk?.toLowerCase() ==
                              product?.namaProduk?.toLowerCase());
                    });
                  } else {
                    setState(() {
                      subTotalHarga += numericValue * (product?.jumlah ?? 0);
                      deliveryProduct.data?[indexCabang].data?.add(product!);
                    });
                  }
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://tokosm.online/uploads/images/${product?.imageUrl}",
                  width: 100,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product?.namaProduk}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: poppins.copyWith(
                          color: backgroundColor1,
                          fontWeight: medium,
                        ),
                      ),
                      Text(
                        "Rp ${product?.diskon != null ? currencyFormatter.format(product?.hargaDiskon) : currencyFormatter.format(product?.harga)}",
                        style: poppins.copyWith(
                          color: backgroundColor1,
                          fontWeight: semiBold,
                        ),
                      ),
                      if (product?.diskon == null ? false : true)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "Rp ${currencyFormatter.format(product?.harga)}",
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
                                "${product?.diskon}%",
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
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              showAlertDialog(context, product);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                catatantextField.text = product?.catatan ?? "";
                                print(
                                    "textfield diisi dengan ${catatantextField.text}");
                              });
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: showCatatanProduct(
                                      product: product ?? DataKeranjang(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.article,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if ((product?.jumlah ?? 0) == 1) {
                                      showAlertDialog(context, product);
                                    } else {
                                      _updateCartProduct(
                                        cuid: "${product?.sId}",
                                        jumlah: "${(product?.jumlah ?? 0) - 1}",
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: backgroundColor2,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${product?.jumlah}",
                                  style: poppins.copyWith(
                                    color: backgroundColor1,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _updateCartProduct(
                                    cuid: "${product?.sId}",
                                    jumlah: "${(product?.jumlah ?? 0) + 1}",
                                  );
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

    Widget header() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: backgroundColor3,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Column(
                children: [
                  Text(
                    "Keranjang",
                    style: poppins.copyWith(
                      color: Colors.white,
                      fontWeight: semiBold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "${cartModel.data?.isEmpty ?? true ? 0 : cartModel.data?[indexCabang].data?.length} Produk",
                    style: poppins.copyWith(
                      color: Colors.white,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
            (cartModel.data?.isEmpty ?? true)
                ? const SizedBox()
                : Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // showModalBottomSheet(
                        //   context: context,
                        //   backgroundColor: Colors.transparent,
                        //   builder: (BuildContext context) {
                        //     return paymentTotal();
                        //   },
                        // );
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    Widget emptyCart() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/bag.png",
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
            "Keranjang anda kosong",
            style: poppins.copyWith(
              fontSize: 15,
              color: backgroundColor3,
              fontWeight: medium,
            ),
          ),
        ],
      );
    }

//  Widget untuk menampilkan bagian view bagian bawah
    Widget bottomView() {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        color: backgroundColor3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Harga",
                  style: poppins.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Rp ${currencyFormatter.format(subTotalHarga)}",
                  style: poppins.copyWith(
                    fontWeight: bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor1,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: Deliverypage(
                      namaCabang: cartModel.data?[indexCabang].namaCabang ?? "",
                      indexCabang: indexCabang,
                      product: deliveryProduct,
                    ),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
              child: Text(
                "Lanjutkan",
                style: poppins,
              ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              header(),
              cartModel.data?.isEmpty ?? true
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: DropdownMenu<String>(
                        width: MediaQuery.sizeOf(context).width - 20,
                        initialSelection:
                            cartModel.data?[indexCabang].namaCabang,
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            indexCabang = cartModel.data
                                    // ignore: unrelated_type_equality_checks
                                    ?.indexWhere((item) =>
                                        item.namaCabang?.toLowerCase() ==
                                        value?.toLowerCase()) ??
                                0;

                            indexCabang = indexCabang < 0 ? 0 : indexCabang;
                            _initCartProduct();
                          });
                        },
                        dropdownMenuEntries: listCabang
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                    ),
              Expanded(
                child: //emptyCart()
                    cartModel.data?.isEmpty ?? true
                        ? emptyCart()
                        : ListView(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              for (var i = 0;
                                  i <
                                      (cartModel.data?[indexCabang].data
                                              ?.length ??
                                          0);
                                  i++)
                                cartItem(index: i),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
              ),
              // ignore: prefer_const_constructors
              cartModel.data?.isEmpty ?? true ? SizedBox() : bottomView(),
            ],
          ),
        ),
      ),
    );
  }
}
