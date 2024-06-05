import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/providers/ulasan_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class UlasanProductPage extends StatefulWidget {
  const UlasanProductPage({super.key});

  @override
  State<UlasanProductPage> createState() => _UlasanProductPageState();
}

class _UlasanProductPageState extends State<UlasanProductPage> {
  @override
  Widget build(BuildContext context) {
    UlasanProvider ulasanProvider = Provider.of<UlasanProvider>(context);

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
            const Divider(
              color: Colors.grey,
              height: 2,
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ulasan Pembeli",
          style: poppins,
        ),
        backgroundColor: backgroundColor3,
      ),
      body: ListView(
        children: [
          for (var i = 0;
              i < (ulasanProvider.ulasanProduct.data?.length ?? 0);
              i++) ...{
            productReviewContent(
              namaPengguna:
                  "${ulasanProvider.ulasanProduct.data?[i].namaPelanggan}",
              rating: ulasanProvider.ulasanProduct.data?[i].rating ?? 0,
              ulasan: ulasanProvider.ulasanProduct.data?[i].ulasan ?? "",
              tanggalUlasan:
                  ulasanProvider.ulasanProduct.data?[i].createdAt ?? "",
            )
          }
        ],
      ),
    );
  }
}
