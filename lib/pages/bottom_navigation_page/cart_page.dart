import 'package:e_shop/models/cart_model.dart';
import 'package:e_shop/models/product_model.dart';
import 'package:e_shop/pages/main_page.dart';
import 'package:e_shop/providers/page_provider.dart';
import 'package:e_shop/providers/product_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    PageProvider pageProvider = Provider.of<PageProvider>(context);
    int subTotalHarga = 0;
    int totalHarga = 0;
    int totalItem = 0;
    final currencyFormatter = NumberFormat('#,##0.00', 'ID');

    void showAlertDialog(BuildContext context, CartModel product){
      showDialog(
          context: context,
          builder: (BuildContext context){
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
                  "Anda yakin untuk menghapus ${product.product?.productName} dari keranjang?",
                  style: poppins.copyWith(
                    color: backgroundColor1
                  ),
                  textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                    onPressed: (){
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
                  onPressed: (){
                    setState(() {
                      Navigator.pop(context);
                      productProvider.cartData.removeWhere((element) => element.product!.urlImg == product.product!.urlImg);
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


    Widget cartItem({required CartModel product}){

      String? numericString = product.product?.productPrice?.split(",")[0].replaceAll(RegExp(r'[^0-9]'), ''); // Removes non-numeric characters
      int numericValue = int.parse(numericString!); // Parses the string as an integer


      subTotalHarga += numericValue * product.numberOfItem;
      totalHarga = subTotalHarga + 10000;
      print("harganya adalah $subTotalHarga");

      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset:  const Offset(2, 8), // Shadow position
            ),
          ]
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.product!.urlImg.toString(),
                width: 130,
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
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.product!.productName.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: poppins.copyWith(
                        color: backgroundColor1,
                        fontWeight: medium,
                      ),
                    ),
                    Text(
                      product.product!.productPrice.toString(),
                      style: poppins.copyWith(
                        color: backgroundColor1,
                        fontWeight: semiBold,
                      ),
                    ),

                    if(product.product!.isDiscount ?? false)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              product.product!.beforeDiscountPrice.toString(),
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
                              product.product!.discountPercentage.toString(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
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
                        Row(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  if(product.numberOfItem > 1){
                                    productProvider.cartData.removeWhere((element) => element.product!.urlImg == product.product!.urlImg);
                                    product.numberOfItem -= 1;
                                    if (product.numberOfItem > 0){
                                      productProvider.cartData.add(
                                        CartModel(
                                          product: product.product,
                                          numberOfItem: product.numberOfItem,
                                        ),
                                      );
                                    }
                                  }else{
                                    showAlertDialog(context, product);
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
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                product.numberOfItem.toString(),
                                style: poppins.copyWith(
                                  color: backgroundColor1,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  productProvider.cartData.removeWhere((element) => element.product!.urlImg == product.product!.urlImg);
                                  product.numberOfItem += 1;
                                  if (product.numberOfItem < 99){
                                    productProvider.cartData.add(
                                      CartModel(
                                        product: product.product,
                                        numberOfItem: product.numberOfItem,
                                      ),
                                    );
                                  }
                                });
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
      );
    }



    Widget paymentTotalItem({required String title, required String value, required double bottomMargin}){
      return Container(
        margin: EdgeInsets.only(bottom: bottomMargin),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    title,
                    style: poppins.copyWith(
                      color: backgroundColor1,
                      fontWeight: medium,
                    ),
                ),
                Text(
                    value,
                    style: poppins.copyWith(
                    color: backgroundColor1,
                    fontWeight: medium,
                  ),
                )
              ],
            ),
            Divider(color: backgroundColor1,
              thickness: 1,)
          ],
        ),
      );
    }

    Widget paymentTotal(){
      return Container(
        alignment: Alignment.center,
        height: 300,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
              BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 4,
              offset:  const Offset(0, 8), // Shadow position
            ),
          ],
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8, bottom: 8),
            child: Text("Ringkasan Pembayaran", style: poppins.copyWith(
              color: backgroundColor1,
              fontWeight: semiBold,
              fontSize: 18,
            ),),
          ),
          paymentTotalItem(title: "Sub Total", value: "Rp ${currencyFormatter.format(subTotalHarga)}", bottomMargin: 10),
          paymentTotalItem(title: "Ongkos Kirim", value: "Rp ${currencyFormatter.format(10000)}", bottomMargin: 10),
          paymentTotalItem(title: "Total Harga", value: "Rp ${currencyFormatter.format(totalHarga)}", bottomMargin: 10),

          Container(
            width: double.infinity,
            child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  pageProvider.currentIndex = 3;
                },
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Lanjutkan",
                    style: poppins.copyWith(
                      color: Colors.white
                    ),
                  ),
                ),
            ),
          ),

          ],
        ),
      );
    }

    Widget header(){
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
                    "${productProvider.cartData.length} Produk",
                    style: poppins.copyWith(
                      color: Colors.white,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
            ),
            productProvider.cartData.isEmpty ? const SizedBox() : Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context){
                      return paymentTotal();
                    },
                  );
                },
                child: const Icon(
                  Icons.local_shipping,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget emptyCart(){
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
              Expanded(
                child: //emptyCart()
                productProvider.cartData.isEmpty ? emptyCart() :
                ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    for(var i=0; i<productProvider.cartData.length; i++)
                    cartItem(product: productProvider.cartData[i]),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
