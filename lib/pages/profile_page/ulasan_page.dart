import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/ulasan_model.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/providers/ulasan_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class UlasanPage extends StatefulWidget {
  const UlasanPage({super.key});

  @override
  State<UlasanPage> createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  UlasanModel ulasanModel = UlasanModel();
  TextEditingController searchTextFieldController = TextEditingController();
  FocusNode searchTextFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initUlasanData();
  }

  _initUlasanData() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    UlasanProvider ulasanProvider =
        Provider.of<UlasanProvider>(context, listen: false);

    if (await ulasanProvider.getRiwayatUlasan(
        token: loginProvider.loginModel.token ?? "",
        search: searchTextFieldController.text)) {
      setState(() {
        ulasanModel = ulasanProvider.ulasanModel;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Widget ulasanItem({
      required int index,
    }) {
      var ulasan = ulasanModel.data?[index];
      DateTime dateTime =
          DateTime.parse(ulasan?.createdAt ?? "${DateTime.now()}");
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingStars(
                        value: double.parse(ulasan?.rating.toString() ?? "0"),
                        onValueChanged: (v) {
                          //
                          setState(() {
                            // value = v;
                          });
                        },
                        starBuilder: (index, color) => Icon(
                          Icons.star,
                          size: 20,
                          color: color,
                        ),
                        starCount: 5,
                        starSize: 20,
                        valueLabelColor: const Color(0xff9b9b9b),
                        valueLabelTextStyle: poppins,
                        valueLabelRadius: 10,
                        maxValue: 5,
                        starSpacing: 2,
                        maxValueVisibility: true,
                        valueLabelVisibility: false,
                        animationDuration: const Duration(milliseconds: 1000),
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: backgroundColor2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        formattedDate,
                        style: poppins,
                      ),
                    ],
                  ),
                  Text(
                    ulasan?.namaProduk ?? "",
                    style: poppins.copyWith(
                      fontWeight: bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ulasan?.ulasan ?? "",
                    style: poppins.copyWith(
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
          ],
        ),
      );
    }

    Widget searchUlasanView() {
      return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              print("search object: ${searchTextFieldController.text}");
            });
          },
          textInputAction: TextInputAction.search,
          controller: searchTextFieldController,
          cursorColor: backgroundColor1,
          // focusNode: searchTextFieldFocusNode,
          onFieldSubmitted: (_) {
            print(
                "object yang dicari adalah ${searchTextFieldController.text}");
            _initUlasanData();
          },
          decoration: InputDecoration(
            hintText: "Cari Ulasan",
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

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Ulasan",
            style: poppins,
          ),
          centerTitle: true,
          backgroundColor: backgroundColor3,
        ),
        body: ListView(
          children: [
            searchUlasanView(),
            const SizedBox(
              height: 10,
            ),
            if (ulasanModel.data?.isEmpty ?? true) ...{
              Center(
                child: Text(
                  "Tidak ada data",
                  style: poppins,
                ),
              ),
            } else ...{
              for (var i = 0; i < ((ulasanModel.data?.length ?? 1)); i++) ...{
                ulasanItem(
                  index: i,
                ),
              }
            }
          ],
        ));
  }
}
