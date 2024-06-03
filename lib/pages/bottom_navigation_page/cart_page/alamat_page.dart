import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokoSM/models/alamat_model.dart';
import 'package:tokoSM/providers/alamat_provider.dart';
import 'package:tokoSM/providers/login_provider.dart';
import 'package:tokoSM/theme/theme.dart';

class AlamatPage extends StatefulWidget {
  const AlamatPage({super.key});

  @override
  State<AlamatPage> createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  AlamatModel alamatModel = AlamatModel();
  List<bool> isSelected = [];

  @override
  void initState() {
    _initAlamatData();
    super.initState();
  }

  _initAlamatData() async {
    AlamatProvider alamatProvider =
        Provider.of<AlamatProvider>(context, listen: false);
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);

    if (await alamatProvider.getAlamat(
        token: loginProvider.loginModel.token ?? "")) {
      setState(() {
        alamatModel = alamatProvider.alamatModel;
        for (var i = 0; i < (alamatModel.data?.length ?? 0); i++) {
          if (alamatProvider.deliveryAlamat.data?.first.namaAlamat
                  ?.toLowerCase() ==
              alamatProvider.alamatModel.data?[i].namaAlamat?.toLowerCase()) {
            isSelected.add(true);
          } else {
            if (alamatProvider.deliveryAlamat.data?.isEmpty ?? true && i == 0) {
              isSelected.add(true);
            } else {
              isSelected.add(false);
            }
          }
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Gagal mendapatkan data alamat",
          style: poppins,
        ),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    AlamatProvider alamatProvider = Provider.of<AlamatProvider>(context);
    Widget alamatItem({required int index}) {
      var alamat = alamatModel.data?[index];
      return InkWell(
        onTap: () {
          setState(() {
            isSelected = isSelected.map((e) => e = false).toList();
            isSelected[index] = !isSelected[index];
            if (isSelected[index] == true) {
              alamatProvider.deliveryAlamat =
                  AlamatModel.fromJson(alamatProvider.alamatModel.toJson());
              alamatProvider.deliveryAlamat.data?.clear();
              alamatProvider.deliveryAlamat.data?.add(alamat ?? Data());
            }
          });
        },
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected[index] == true ? backgroundColor1 : Colors.grey,
              width: isSelected[index] == true ? 3 : 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${alamat?.namaAlamat}",
                style: poppins.copyWith(
                  fontWeight: bold,
                  fontSize: 11,
                ),
              ),
              Text(
                "${alamat?.namaPenerima}",
                style: poppins.copyWith(
                  fontWeight: bold,
                ),
              ),
              Text(
                "${alamat?.telpPenerima}",
                style: poppins.copyWith(
                  fontSize: 11,
                ),
              ),
              Text(
                "${alamat?.alamatLengkap}, ${alamat?.kelurahan?.toLowerCase()}, ${alamat?.kecamatan?.toLowerCase()}, ${alamat?.kabkota?.toLowerCase()}, ${alamat?.provinsi?.toLowerCase()}, ${alamat?.kodepos?.toLowerCase()}",
                style: poppins.copyWith(
                  fontSize: 11,
                ),
              ),
              alamat?.catatan?.isEmpty ?? true
                  ? SizedBox()
                  : Text(
                      "[tokoSM Note: ${alamat?.catatan}]",
                      style: poppins.copyWith(
                        fontSize: 11,
                      ),
                    ),
              alamat?.lat == null || alamat?.lon == null
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: backgroundColor3,
                        ),
                        Expanded(
                          child: Text(
                            "Sudah Pinpoint",
                            style: poppins.copyWith(
                              fontWeight: bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Text(
                        "Ubah Alamat",
                        style: poppins.copyWith(
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Alamat",
          style: poppins,
        ),
        backgroundColor: backgroundColor3,
        actions: [
          Container(
              margin: const EdgeInsets.only(
                right: 10,
              ),
              child: Center(
                  child: Text(
                "Tambah Alamat",
                style: poppins,
              ))),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          for (var i = 0; i < (alamatModel.data?.length ?? 0); i++) ...{
            alamatItem(index: i),
          }
        ],
      ),
    );
  }
}
