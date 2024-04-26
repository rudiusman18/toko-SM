class DetailProductModel {
  String? message;
  Data? data;

  DetailProductModel({this.message, this.data});

  DetailProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? produkKategoriId;
  dynamic kodeProduk;
  dynamic barcodeProduk;
  dynamic namaProduk;
  dynamic satuanProduk;
  dynamic golonganProduk;
  dynamic merkProduk;
  dynamic deskripsiProduk;
  dynamic beratProduk;
  dynamic hargaPokok;
  dynamic multisatuanJumlah;
  dynamic multisatuanUnit;
  dynamic gambar1;
  dynamic gambar2;
  dynamic gambar3;
  dynamic gambar4;
  dynamic gambar5;
  dynamic isAktiva;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  List<String>? gambar;
  List<Stok>? stok;
  List<Harga>? harga;
  double? rating;

  Data(
      {this.id,
        this.produkKategoriId,
        this.kodeProduk,
        this.barcodeProduk,
        this.namaProduk,
        this.satuanProduk,
        this.golonganProduk,
        this.merkProduk,
        this.deskripsiProduk,
        this.beratProduk,
        this.hargaPokok,
        this.multisatuanJumlah,
        this.multisatuanUnit,
        this.gambar1,
        this.gambar2,
        this.gambar3,
        this.gambar4,
        this.gambar5,
        this.isAktiva,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.gambar,
        this.stok,
        this.harga,
        this.rating});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produkKategoriId = json['produk_kategori_id'];
    kodeProduk = json['kode_produk'];
    barcodeProduk = json['barcode_produk'];
    namaProduk = json['nama_produk'];
    satuanProduk = json['satuan_produk'];
    golonganProduk = json['golongan_produk'];
    merkProduk = json['merk_produk'];
    deskripsiProduk = json['deskripsi_produk'];
    beratProduk = json['berat_produk'];
    hargaPokok = json['harga_pokok'];
    multisatuanJumlah = json['multisatuan_jumlah'];
    multisatuanUnit = json['multisatuan_unit'];
    gambar1 = json['gambar1'];
    gambar2 = json['gambar2'];
    gambar3 = json['gambar3'];
    gambar4 = json['gambar4'];
    gambar5 = json['gambar5'];
    isAktiva = json['is_aktiva'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    gambar = json['gambar'].cast<String>();
    if (json['stok'] != null) {
      stok = <Stok>[];
      json['stok'].forEach((v) {
        stok!.add(new Stok.fromJson(v));
      });
    }
    if (json['harga'] != null) {
      harga = <Harga>[];
      json['harga'].forEach((v) {
        harga!.add(new Harga.fromJson(v));
      });
    }
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produk_kategori_id'] = this.produkKategoriId;
    data['kode_produk'] = this.kodeProduk;
    data['barcode_produk'] = this.barcodeProduk;
    data['nama_produk'] = this.namaProduk;
    data['satuan_produk'] = this.satuanProduk;
    data['golongan_produk'] = this.golonganProduk;
    data['merk_produk'] = this.merkProduk;
    data['deskripsi_produk'] = this.deskripsiProduk;
    data['berat_produk'] = this.beratProduk;
    data['harga_pokok'] = this.hargaPokok;
    data['multisatuan_jumlah'] = this.multisatuanJumlah;
    data['multisatuan_unit'] = this.multisatuanUnit;
    data['gambar1'] = this.gambar1;
    data['gambar2'] = this.gambar2;
    data['gambar3'] = this.gambar3;
    data['gambar4'] = this.gambar4;
    data['gambar5'] = this.gambar5;
    data['is_aktiva'] = this.isAktiva;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['gambar'] = this.gambar;
    if (this.stok != null) {
      data['stok'] = this.stok!.map((v) => v.toJson()).toList();
    }
    if (this.harga != null) {
      data['harga'] = this.harga!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    return data;
  }
}

class Stok {
  int? cabangId;
  String? cabang;
  int? stok;

  Stok({this.cabangId, this.cabang, this.stok});

  Stok.fromJson(Map<String, dynamic> json) {
    cabangId = json['cabang_id'];
    cabang = json['cabang'];
    stok = json['stok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cabang_id'] = this.cabangId;
    data['cabang'] = this.cabang;
    data['stok'] = this.stok;
    return data;
  }
}

class Harga {
  int? cabangId;
  String? cabang;
  int? harga;
  int? hargaDiskon;
  int? diskon;

  Harga(
      {this.cabangId, this.cabang, this.harga, this.hargaDiskon, this.diskon});

  Harga.fromJson(Map<String, dynamic> json) {
    cabangId = json['cabang_id'];
    cabang = json['cabang'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
    diskon = json['diskon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cabang_id'] = this.cabangId;
    data['cabang'] = this.cabang;
    data['harga'] = this.harga;
    data['harga_diskon'] = this.hargaDiskon;
    data['diskon'] = this.diskon;
    return data;
  }
}
