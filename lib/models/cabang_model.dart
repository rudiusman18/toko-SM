class CabangModel {
  String? message;
  List<DataCabang>? data;

  CabangModel({this.message, this.data});

  CabangModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DataCabang>[];
      json['data'].forEach((v) {
        data!.add(DataCabang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCabang {
  int? id;
  int? cabangKelasId;
  String? namaCabang;
  String? alamatCabang;
  double? latitude;
  double? longitude;
  int? jarak;
  String? jarakSatuan;
  bool? terdekat;

  DataCabang(
      {this.id,
      this.cabangKelasId,
      this.namaCabang,
      this.alamatCabang,
      this.latitude,
      this.longitude,
      this.jarak,
      this.jarakSatuan,
      this.terdekat});

  DataCabang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangKelasId = json['cabang_kelas_id'];
    namaCabang = json['nama_cabang'];
    alamatCabang = json['alamat_cabang'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    jarak = json['jarak'];
    jarakSatuan = json['jarak_satuan'];
    terdekat = json['terdekat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cabang_kelas_id'] = cabangKelasId;
    data['nama_cabang'] = namaCabang;
    data['alamat_cabang'] = alamatCabang;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['jarak'] = jarak;
    data['jarak_satuan'] = jarakSatuan;
    data['terdekat'] = terdekat;
    return data;
  }
}
