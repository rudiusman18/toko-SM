import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokoSM/models/wilayah_model.dart';
import 'package:tokoSM/providers/alamat_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class TambahAlamatPage extends StatefulWidget {
  @override
  _TambahAlamatPageState createState() => new _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  List<String> textDatabase = [];

  TextEditingController namaAlamatTextField = TextEditingController();
  TextEditingController namaPenerimaTextField = TextEditingController();
  TextEditingController telpPenerimaTextField = TextEditingController();
  TextEditingController alamatLengkapTextField = TextEditingController();
  TextEditingController wilayahTextField = TextEditingController();
  TextEditingController kodeposTextField = TextEditingController();
  TextEditingController catatanTextField = TextEditingController();
  TextEditingController coordinateTextField = TextEditingController();

  @override
  void initState() {
    _initWilayahDatabase();
    super.initState();
  }

  _initWilayahDatabase() async {
    String data = await rootBundle.loadString('assets/wilayah.json');
    var jsonResult = jsonDecode(data);
    var wilayah = WilayahModel.fromJson(jsonResult);

    setState(() {
      textDatabase = wilayah.data?.map((e) => (e.value) ?? "").toList() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);
    AlamatProvider alamatProvider = Provider.of<AlamatProvider>(context);
    Widget customtextFormField({
      required IconData icon,
      required String title,
      required TextInputType keyboardType,
      required TextEditingController controller,
      bool readOnly = false,
    }) {
      return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: poppins.copyWith(
                fontWeight: medium,
                fontSize: 14,
                color: backgroundColor1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              onTap: () {
                if (title.toLowerCase() == "koordinat") {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const Maps(),
                      type: PageTransitionType.fade,
                    ),
                  ).then((value) => setState(() {}));
                }
              },
              readOnly: readOnly,
              maxLines: title.toLowerCase() == "catatan" ? 4 : 1,
              textInputAction: title.toLowerCase() == "catatan"
                  ? TextInputAction.newline
                  : TextInputAction.next,
              style: poppins.copyWith(
                color: backgroundColor1,
              ),
              keyboardType: keyboardType,
              cursorColor: backgroundColor1,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: title.toLowerCase() == "catatan"
                    ? const EdgeInsets.all(20)
                    : const EdgeInsets.all(0),
                hintText: "...",
                hintStyle: poppins.copyWith(
                  color: backgroundColor1,
                ),
                prefixIcon: Icon(icon),
                prefixIconColor: backgroundColor1,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor1,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: backgroundColor3,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    coordinateTextField.text = alamatProvider.dataLatLong;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Tambah Alamat",
              style: poppins,
            ),
            backgroundColor: backgroundColor3,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.home,
                      title: "Nama Alamat",
                      keyboardType: TextInputType.text,
                      controller: namaAlamatTextField,
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.user,
                      title: "Nama Penerima",
                      keyboardType: TextInputType.text,
                      controller: namaPenerimaTextField,
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.phone,
                      title: "telp Penerima",
                      keyboardType: TextInputType.phone,
                      controller: telpPenerimaTextField,
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.home1,
                      title: "Alamat Lengkap",
                      keyboardType: TextInputType.text,
                      controller: alamatLengkapTextField,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        "Wilayah",
                        style: poppins.copyWith(
                          fontWeight: medium,
                          color: backgroundColor1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: backgroundColor1,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Icon(
                              Icons.map_rounded,
                              size: 25,
                              color: backgroundColor1,
                            ),
                          ),
                          Expanded(
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.dialog(
                                showSelectedItems: true,
                                showSearchBox: true,
                                disabledItemFn: (String s) => s.startsWith('I'),
                              ),
                              items: textDatabase,
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "...",
                                ),
                              ),
                              selectedItem: wilayahTextField.text,
                              onChanged: (value) {
                                setState(() {
                                  wilayahTextField.text = value ?? "";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.mailbox,
                      title: "Kode Pos",
                      keyboardType: TextInputType.number,
                      controller: kodeposTextField,
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.notes,
                      title: "Catatan",
                      keyboardType: TextInputType.multiline,
                      controller: catatanTextField,
                    ),
                    customtextFormField(
                      icon: SolarIconsBold.mapPoint,
                      title: "Koordinat",
                      keyboardType: TextInputType.text,
                      controller: coordinateTextField,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        "Batal",
                        style: poppins,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (await alamatProvider.postAlamat(
                            token: loginProvider.loginModel.token ?? "",
                            namaAlamat: namaAlamatTextField.text,
                            namaPenerima: namaPenerimaTextField.text,
                            telpPenerima: telpPenerimaTextField.text,
                            alamatLengkap: alamatLengkapTextField.text,
                            wilayah: wilayahTextField.text,
                            kodePos: kodeposTextField.text,
                            catatan: catatanTextField.text,
                            lat: double.tryParse(
                                coordinateTextField.text.split(",").first),
                            lng: double.tryParse(
                                coordinateTextField.text.split(",").last))) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor1,
                      ),
                      child: Text(
                        "Simpan",
                        style: poppins,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }
}

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  InAppWebViewController? _webViewController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    AlamatProvider alamatProvider = Provider.of<AlamatProvider>(context);

    // Mengakses Maps (webview)
    Widget map() {
      return Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      "https://103.127.132.116/api/v2/map?lat=-7&lng=112&kategori=customer&id=${loginProvider.loginModel.data?.id}")),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  // allowFileAccessFromFileURLs: true,
                  // allowUniversalAccessFromFileURLs: true,
                  mixedContentMode:
                      AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(
                20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "kembali",
                        style: poppins,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor1,
                      ),
                      onPressed: () async {
                        if (await alamatProvider.getLatLongData(
                          token: loginProvider.loginModel.token ?? "",
                          userId:
                              loginProvider.loginModel.data?.id?.toString() ??
                                  "",
                        )) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Simpan",
                        style: poppins,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: map(),
      ),
    );
  }
}
