class CabangModel {
  String? message;
  List<Data>? data;

  CabangModel({this.message, this.data});

  CabangModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? cabangKelasId;
  String? namaCabang;
  String? alamatCabang;
  double? latitude;
  double? longitude;

  Data(
      {this.id,
        this.cabangKelasId,
        this.namaCabang,
        this.alamatCabang,
        this.latitude,
        this.longitude});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangKelasId = json['cabang_kelas_id'];
    namaCabang = json['nama_cabang'];
    alamatCabang = json['alamat_cabang'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cabang_kelas_id'] = this.cabangKelasId;
    data['nama_cabang'] = this.namaCabang;
    data['alamat_cabang'] = this.alamatCabang;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
