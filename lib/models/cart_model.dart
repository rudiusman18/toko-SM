class CartModel {
  String? message;
  List<Data>? data;

  CartModel({this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? namaCabang;
  List<DataKeranjang>? data;

  Data({this.id, this.namaCabang, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaCabang = json['nama_cabang'];
    if (json['data'] != null) {
      data = <DataKeranjang>[];
      json['data'].forEach((v) {
        data!.add(DataKeranjang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_cabang'] = namaCabang;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataKeranjang {
  String? sId;
  int? cabangId;
  int? pelangganId;
  int? produkId;
  String? catatan;
  int? jumlah;
  String? namaProduk;
  String? imageUrl;
  int? harga;
  int? hargaDiskon;
  int? diskon;
  int? stok;
  String? updatedAt;

  DataKeranjang(
      {this.sId,
      this.cabangId,
      this.pelangganId,
      this.produkId,
      this.catatan,
      this.jumlah,
      this.namaProduk,
      this.imageUrl,
      this.harga,
      this.hargaDiskon,
      this.diskon,
      this.stok,
      this.updatedAt});

  DataKeranjang.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    cabangId = json['cabang_id'];
    pelangganId = json['pelanggan_id'];
    produkId = json['produk_id'];
    catatan = json['catatan'];
    jumlah = json['jumlah'];
    namaProduk = json['nama_produk'];
    imageUrl = json['image_url'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
    diskon = json['diskon'];
    stok = json['stok'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['cabang_id'] = cabangId;
    data['pelanggan_id'] = pelangganId;
    data['produk_id'] = produkId;
    data['catatan'] = catatan;
    data['jumlah'] = jumlah;
    data['nama_produk'] = namaProduk;
    data['image_url'] = imageUrl;
    data['harga'] = harga;
    data['harga_diskon'] = hargaDiskon;
    data['diskon'] = diskon;
    data['stok'] = stok;
    data['updated_at'] = updatedAt;
    return data;
  }
}
