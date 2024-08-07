import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tokoSM/models/wilayah_model.dart';
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
              readOnly: readOnly,
              textInputAction: TextInputAction.next,
              style: poppins.copyWith(
                color: backgroundColor1,
              ),
              keyboardType: keyboardType,
              cursorColor: backgroundColor1,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
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
          body: ListView(
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
                        dropdownDecoratorProps: const DropDownDecoratorProps(
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
                keyboardType: TextInputType.text,
                controller: namaAlamatTextField,
              ),
              customtextFormField(
                icon: SolarIconsBold.home,
                title: "Catatan",
                keyboardType: TextInputType.text,
                controller: namaAlamatTextField,
              ),
              customtextFormField(
                icon: SolarIconsBold.mapPoint,
                title: "Koordinat",
                keyboardType: TextInputType.text,
                controller: namaAlamatTextField,
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

    // Mengakses Maps (webview)
    Widget map() {
      return Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(
              "CURRENT URL\n${(url.length > 50) ? "${url.substring(0, 50)}..." : url}"),
        ),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container()),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
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
              // onLoadStart: (InAppWebViewController controller, String url) {
              //   setState(() {
              //     this.url = url;
              //   });
              // },
              // onLoadStop:
              //     (InAppWebViewController controller, String url) async {
              //   setState(() {
              //     this.url = url;
              //   });
              // },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Icon(Icons.arrow_back),
              onPressed: () {
                if (_webViewController != null) {
                  _webViewController?.goBack();
                }
              },
            ),
            ElevatedButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                if (_webViewController != null) {
                  _webViewController?.goForward();
                }
              },
            ),
            ElevatedButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                if (_webViewController != null) {
                  _webViewController?.reload();
                }
              },
            ),
          ],
        ),
      ]);
    }

    return Scaffold(
      body: map(),
    );
  }
}
