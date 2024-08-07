import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tokoSM/models/wilayah_model.dart';
import 'package:tokoSM/providers/cabang_provider.dart';
import 'package:tokoSM/providers/profile_provider.dart';
import 'package:tokoSM/theme/theme.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import '../../providers/login_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameTextField = TextEditingController();
  TextEditingController fullnameTextField = TextEditingController();
  TextEditingController cabangTextField = TextEditingController();
  TextEditingController idCabangTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController telpTextField = TextEditingController();
  TextEditingController alamatTextField = TextEditingController();
  TextEditingController wilayahTextField = TextEditingController();
  TextEditingController tglLahirTextField = TextEditingController();
  TextEditingController jenisKelaminTextField = TextEditingController();

// Wilayah Controller
  WilayahModel wilayah = WilayahModel();
  TextEditingController searchTextFieldController =
      TextEditingController(text: "");
  FocusNode searchTextFieldFocusNode = FocusNode();
  List<String> textDatabase = [];
  List<String> textSuggestion = [];

// DatePicker
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

// simpanButton Controller
  bool isLoading = false;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        tglLahirTextField.text = _selectedDate.split(" ").first;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  _loading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      height: MediaQuery.sizeOf(context).width * 0.3,
                      child: CircularProgressIndicator(
                        color: backgroundColor3,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Loading...", style: poppins),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    ProfileProvider profileProvider = Provider.of(context, listen: false);
    var profile = profileProvider.profileModel.data;
    usernameTextField.text = "${profile?.username}";
    fullnameTextField.text = "${profile?.namaPelanggan}";
    cabangTextField.text = "${profile?.namaCabang}";
    emailTextField.text = "${profile?.emailPelanggan}";
    telpTextField.text = "${profile?.telpPelanggan}";
    alamatTextField.text = "${profile?.alamatPelanggan}";
    wilayahTextField.text =
        "${profile?.provinsi?.toUpperCase()},${profile?.kabkota?.toUpperCase()},${profile?.kecamatan?.toUpperCase()},${profile?.kelurahan?.toUpperCase()}";
    tglLahirTextField.text = "${profile?.tglLahirPelanggan}";
    jenisKelaminTextField.text = "${profile?.jenisKelaminPelanggan}";

    Future.delayed(Duration.zero, () async {
      String data = await rootBundle.loadString('assets/wilayah.json');
      var jsonResult = jsonDecode(data);
      wilayah = WilayahModel.fromJson(jsonResult);

      setState(() {
        textDatabase = wilayah.data?.map((e) => (e.value) ?? "").toList() ?? [];
        print("isi wilayahnya adalah ${textDatabase}");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    CabangProvider cabangProvider = Provider.of<CabangProvider>(context);
    List<String> dataCabang = cabangProvider.cabangModel.data
            ?.map((e) => "${e.namaCabang}")
            .toList() ??
        [];
    idCabangTextField.text =
        "${cabangProvider.cabangModel.data?.where((element) => element.namaCabang?.toLowerCase() == cabangTextField.text.toLowerCase()).first.id}";

    // Digunakan ketika tombol simpan ditekan
    _handleTapSimpan() async {
      var profile = profileProvider.profileModel.data;

      setState(() {
        _loading();
      });

      if (await profileProvider.updateProfile(
          token: loginProvider.loginModel.token ?? "",
          userId: profile?.id ?? 0,
          cabangId: int.parse(idCabangTextField.text),
          username: usernameTextField.text,
          email: emailTextField.text,
          telp: telpTextField.text,
          alamat: alamatTextField.text,
          wilayah: wilayahTextField.text,
          tglLahir: tglLahirTextField.text,
          jenisKelamin: jenisKelaminTextField.text,
          fullname: fullnameTextField.text)) {
        print("data berhasil diupdate");
        setState(() {
          loginProvider.loginModel.data?.cabangId =
              int.parse(idCabangTextField.text);
          loginProvider.loginModel.data?.namaCabang = cabangTextField.text;
        });
      } else {
        print("data gagal diupdate");
      }
      setState(() {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }

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

    Widget getWilayah({required WilayahModel wilayah}) {
      print("isi wilayahnya adalah: ${wilayah.data?.first.name}");

      return StatefulBuilder(
        builder: (context, stateSetter) {
          return Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  stateSetter(() {
                    print(
                        "search object: ${searchTextFieldController.text} dengan ${value.toLowerCase()}");
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
                decoration: InputDecoration(
                  hintText: "Cari Wilayah",
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
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < textSuggestion.length; i++)
                      Text("${textSuggestion[i]}"),
                  ],
                ),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Profil",
            style: poppins,
          ),
          backgroundColor: backgroundColor3,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            customtextFormField(
              icon: Icons.person,
              title: "Nama Lengkap",
              keyboardType: TextInputType.name,
              controller: fullnameTextField,
            ),
            customtextFormField(
              icon: Icons.person,
              title: "Nama Pengguna",
              keyboardType: TextInputType.name,
              controller: usernameTextField,
            ),
            customtextFormField(
              icon: Icons.email,
              title: "Email",
              keyboardType: TextInputType.emailAddress,
              controller: emailTextField,
            ),
            customtextFormField(
              icon: Icons.phone,
              title: "Telp",
              keyboardType: TextInputType.phone,
              controller: telpTextField,
            ),
            customtextFormField(
              icon: Icons.house,
              title: "Alamat",
              keyboardType: TextInputType.streetAddress,
              controller: alamatTextField,
            ),

            // NOTE: wilayah
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

            // NOTE: Tanggal lahir
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Tanggal Lahir",
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
                      Icons.date_range,
                      size: 25,
                      color: backgroundColor1,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: MediaQuery.sizeOf(context).width,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: SfDateRangePicker(
                                    initialSelectedDate: DateTime.tryParse(
                                      tglLahirTextField.text,
                                    ),
                                    onSelectionChanged: _onSelectionChanged,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now()
                                            .subtract(const Duration(days: 4)),
                                        DateTime.now()
                                            .add(const Duration(days: 3))),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text(
                        tglLahirTextField.text == ""
                            ? "..."
                            : tglLahirTextField.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NOTE: Jenis Kelamin
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Jenis Kelamin",
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
                      Icons.transgender,
                      size: 25,
                      color: backgroundColor1,
                    ),
                  ),
                  Expanded(
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      items: ["laki-laki", "Perempuan"],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "...",
                        ),
                      ),
                      selectedItem: jenisKelaminTextField.text,
                      onChanged: (value) {
                        setState(() {
                          jenisKelaminTextField.text = value ?? "";
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Cabang",
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
                      Icons.store,
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
                      items: dataCabang,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "...",
                        ),
                      ),
                      selectedItem: cabangTextField.text,
                      onChanged: (value) {
                        setState(() {
                          cabangTextField.text = value ?? "";
                          idCabangTextField.text =
                              "${cabangProvider.cabangModel.data?.where((element) => element.namaCabang?.toLowerCase() == value?.toLowerCase()).first.id}";
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: backgroundColor3,
                  ),
                  onPressed: _handleTapSimpan,
                  child: Text(
                    "Simpan",
                  ),
                )),
          ],
        ));
  }
}
