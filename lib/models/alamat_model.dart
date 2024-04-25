class AlamatModel {
  String? message;
  List<Data>? data;

  AlamatModel({this.message, this.data});

  AlamatModel.fromJson(Map<String, dynamic> json) {
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
  String? namaAlamat;
  String? namaPenerima;
  String? telpPenerima;
  String? alamatLengkap;
  String? provinsi;
  String? kabkota;
  String? kecamatan;
  String? kelurahan;
  String? kodepos;
  String? catatan;
  double? lat;
  double? lon;
  int? isUtama;
  Null? updatedAt;

  Data(
      {this.id,
        this.namaAlamat,
        this.namaPenerima,
        this.telpPenerima,
        this.alamatLengkap,
        this.provinsi,
        this.kabkota,
        this.kecamatan,
        this.kelurahan,
        this.kodepos,
        this.catatan,
        this.lat,
        this.lon,
        this.isUtama,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaAlamat = json['nama_alamat'];
    namaPenerima = json['nama_penerima'];
    telpPenerima = json['telp_penerima'];
    alamatLengkap = json['alamat_lengkap'];
    provinsi = json['provinsi'];
    kabkota = json['kabkota'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    kodepos = json['kodepos'];
    catatan = json['catatan'];
    lat = json['lat'];
    lon = json['lon'];
    isUtama = json['is_utama'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_alamat'] = this.namaAlamat;
    data['nama_penerima'] = this.namaPenerima;
    data['telp_penerima'] = this.telpPenerima;
    data['alamat_lengkap'] = this.alamatLengkap;
    data['provinsi'] = this.provinsi;
    data['kabkota'] = this.kabkota;
    data['kecamatan'] = this.kecamatan;
    data['kelurahan'] = this.kelurahan;
    data['kodepos'] = this.kodepos;
    data['catatan'] = this.catatan;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['is_utama'] = this.isUtama;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
