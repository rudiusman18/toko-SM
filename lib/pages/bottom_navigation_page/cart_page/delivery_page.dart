import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/cart_model.dart';
import 'package:tokoSM/models/kurir_model.dart';
import 'package:tokoSM/pages/bottom_navigation_page/cart_page/alamat_page.dart';
import 'package:tokoSM/providers/kurir_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class Deliverypage extends StatefulWidget {
  final String namaCabang;
  final int indexCabang;
  final CartModel product;
  const Deliverypage(
      {super.key, required this.namaCabang, required this.indexCabang, required this.product});

  @override
  State<Deliverypage> createState() => _DeliverypageState();
}

class _DeliverypageState extends State<Deliverypage> {
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  String kurirDigunakan = "";

  @override
  Widget build(BuildContext context) {
    double totalHargaRingkasan = 0.0;
    KurirProvider kurirProvider = Provider.of<KurirProvider>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    _loading(){
      showDialog(context: context, builder: (BuildContext context){
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    height: MediaQuery.sizeOf(context).width * 0.3,
                    child: CircularProgressIndicator(
                      color: backgroundColor3,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Loading...",style: poppins),
                ],
              ),
            ),
          ),
        );
      });
    }

    Widget alamatPengiriman() {
      return InkWell(
        onTap: (){
          Navigator.push(context, PageTransition(child: AlamatPage(), type: PageTransitionType.rightToLeft,));
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.all(
            20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alamat Pengiriman",
                      style: poppins.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: backgroundColor3,
                        ),
                        Text(
                          "ini isinya alamat",
                          style: poppins.copyWith(
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "ini isinya alamat lebih detail ini isinya alamat lebih detail ini isinya alamat lebih detail ini isinya alamat lebih detail",
                      style: poppins.copyWith(
                        fontWeight: light,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    Widget productItem({required int index}) {
      var product = widget.product.data?[widget.indexCabang].data?[index];
      var totalharga = (product?.jumlah ?? 0) * ((product?.diskon != null) ? (product?.harga ?? 0) : (product?.hargaDiskon ?? 0));
      totalHargaRingkasan += totalharga;
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.red,
              child: Image.network(
                "https://tokosm.online/uploads/images/${product?.imageUrl}",
                width: 80,
                height: 80,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${product?.namaProduk}",
                      style: poppins,
                    ),
                    Text(
                      "${product?.jumlah} x Rp ${currencyFormatter.format(product?.diskon != null ? product?.harga : product?.hargaDiskon)}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "Total: Rp ${currencyFormatter.format(totalharga)}",
                      style: poppins.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "\"${product?.catatan}\"",
                      style: poppins.copyWith(
                        fontSize: 10,
                        fontWeight: light,
                        color: Colors.grey,
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

    Widget listKurir({required int index}){
        return InkWell(
          onTap: (){
            setState(() {
              kurirDigunakan = "${kurirProvider.kurirModel.data?[index].namaKurir}";
              Navigator.pop(context);
            });
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${kurirProvider.kurirModel.data?[index].namaKurir} (Rp${currencyFormatter.format(15000)})", style: poppins.copyWith(
                  fontWeight: bold,
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
        );
    }

    Widget kurir() {
      return InkWell(
        onTap: (){
         setState(() {
           kurirProvider.kurirModel.data = null;
           print("apakah saat ini kurir model dalam keadaan koson: ${kurirProvider.kurirModel.data?.isEmpty ?? true}");
         });
         if(kurirProvider.kurirModel.data?.isEmpty ?? true){
           Future.delayed(Duration.zero, ()async{
             setState(() {
               _loading();
             });
             if(await kurirProvider.getKurir(token: loginProvider.loginModel.token ?? "", cabangId: "${widget.product.data?[widget.indexCabang].id}")){
               // print("isi kurir adalah: ${kurirProvider.kurirModel.data?.first.namaKurir}");
               setState(() {
                Navigator.pop(context);
               });
               showModalBottomSheet<void>(
                 context: context,
                 builder: (BuildContext context) {
                   return Container(
                     padding: const EdgeInsets.only(left: 20, right: 20, top: 10,),
                     height: 400,
                     color: Colors.white,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                         Row(
                           children: [
                             InkWell(
                               onTap: (){
                                 Navigator.pop(context);
                               },
                               child: const Icon(
                                 Icons.close,
                                 size: 30,
                               ),
                             ),
                             const SizedBox(width: 10,),
                             Text("Kurir", style: poppins.copyWith(
                               fontSize: 20,
                               fontWeight: bold,
                             ),
                             ),
                           ],
                         ),
                         Container(
                           margin: EdgeInsets.symmetric(vertical: 20),
                           padding: EdgeInsets.all(20),
                           width: double.infinity,
                           decoration: BoxDecoration(
                             border: Border.all(
                               width: 1,
                               color: Colors.grey,
                             ),
                             borderRadius: BorderRadius.circular(20,),
                           ),
                           child: Row(
                             children: [
                               const Icon(Icons.storefront,),
                               const SizedBox(width: 10,),
                               Text("Dikirim dari cabang ${widget.namaCabang}", style: poppins,),
                             ],
                           ),
                         ),
                         Expanded(
                           child: kurirProvider.kurirModel.data?.isEmpty ?? true ? Center(child: Text("Tidak ada data kurir", style: poppins,),) : ListView(
                             children: [
                               for(var i=0; i<(kurirProvider.kurirModel.data?.length ?? 0);i++)listKurir(index: i)
                             ],
                           ),
                         )
                       ],
                     ),
                   );
                 },
               );
             }else{
               setState(() {
                 Navigator.pop(context);
               });
             }
           });
         }

        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (kurirDigunakan == "" ? "Pilih Kurir" : "$kurirDigunakan (Rp ${currencyFormatter.format(15000)})"),
                  style: poppins.copyWith(
                    fontWeight: bold,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    Widget ringkasanItem({required String title, required String value}) {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: poppins.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
                child: Text(
              value,
              style: poppins.copyWith(
                fontSize: 12,
              ),
              textAlign: TextAlign.end,
            )),
          ],
        ),
      );
    }

    Widget ringkasan() {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ringkasan",
              style: poppins.copyWith(
                fontWeight: bold,
              ),
            ),
            ringkasanItem(
              title: "Total harga (jumlah barang)",
              value: "Rp ${currencyFormatter.format(totalHargaRingkasan)}",
            ),
            ringkasanItem(
              title: "Total ongkos kirim",
              value: kurirDigunakan == "" ? "-" : "Rp ${currencyFormatter.format(15000)}",
            ),
            ringkasanItem(
              title: "Total belanja",
              value: "Rp ${currencyFormatter.format(totalHargaRingkasan + (kurirDigunakan == "" ? 0 : 15000))}",
            ),
          ],
        ),
      );
    }

    Widget product() {
      return Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "Cabang ${widget.namaCabang}",
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
            for (var i = 0; i < (widget.product.data?[widget.indexCabang].data?.length ?? 0); i++) productItem(index: i),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor3,
        title: Text(
          "Pengiriman",
          style: poppins.copyWith(
            fontWeight: bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          alamatPengiriman(),
          product(),
          kurir(),
          ringkasan(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor3,
              ),
              child: Text(
                "Pilih Pembayaran",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
