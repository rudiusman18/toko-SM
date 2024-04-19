class FavoriteModel {
  String? message;
  List<Data>? data;

  FavoriteModel({this.message, this.data});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
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
  int? produkId;
  int? pelangganId;
  String? namaProduk;
  String? imageUrl;
  int? harga;
  int? hargaDiskon;
  int? diskon;
  double? rating;

  Data(
      {this.sId,
      this.produkId,
      this.pelangganId,
      this.namaProduk,
      this.imageUrl,
      this.harga,
      this.hargaDiskon,
      this.diskon,
      this.rating});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    produkId = json['produk_id'];
    pelangganId = json['pelanggan_id'];
    namaProduk = json['nama_produk'];
    imageUrl = json['image_url'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
    diskon = json['diskon'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['produk_id'] = produkId;
    data['pelanggan_id'] = pelangganId;
    data['nama_produk'] = namaProduk;
    data['image_url'] = imageUrl;
    data['harga'] = harga;
    data['harga_diskon'] = hargaDiskon;
    data['diskon'] = diskon;
    data['rating'] = rating;
    return data;
  }
}
