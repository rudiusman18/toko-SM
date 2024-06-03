class UlasanModel {
  String? message;
  List<Data>? data;

  UlasanModel({this.message, this.data});

  UlasanModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? sId;
  String? namaProduk;
  String? namaPelanggan;
  int? rating;
  String? ulasan;
  String? createdAt;

  Data(
      {this.sId,
      this.namaProduk,
      this.namaPelanggan,
      this.rating,
      this.ulasan,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    namaProduk = json['nama_produk'];
    namaPelanggan = json['nama_pelanggan'];
    rating = json['rating'];
    ulasan = json['ulasan'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['nama_produk'] = namaProduk;
    data['nama_pelanggan'] = namaPelanggan;
    data['rating'] = rating;
    data['ulasan'] = ulasan;
    data['created_at'] = createdAt;
    return data;
  }
}
