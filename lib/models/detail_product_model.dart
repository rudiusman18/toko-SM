class DetailProductModel {
  String? message;
  Data? data;

  DetailProductModel({this.message, this.data});

  DetailProductModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
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
  String? kat1;
  String? kat1Slug;
  String? kat2;
  String? kat2Slug;
  String? kat3;
  String? kat3Slug;
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
      this.kat1,
      this.kat1Slug,
      this.kat2,
      this.kat2Slug,
      this.kat3,
      this.kat3Slug,
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
    kat1 = json['kat1'];
    kat1Slug = json['kat1_slug'];
    kat2 = json['kat2'];
    kat2Slug = json['kat2_slug'];
    kat3 = json['kat3'];
    kat3Slug = json['kat3_slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    gambar = json['gambar'].cast<String>();
    if (json['stok'] != null) {
      stok = <Stok>[];
      json['stok'].forEach((v) {
        stok!.add(Stok.fromJson(v));
      });
    }
    if (json['harga'] != null) {
      harga = <Harga>[];
      json['harga'].forEach((v) {
        harga!.add(Harga.fromJson(v));
      });
    }
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['produk_kategori_id'] = produkKategoriId;
    data['kode_produk'] = kodeProduk;
    data['barcode_produk'] = barcodeProduk;
    data['nama_produk'] = namaProduk;
    data['satuan_produk'] = satuanProduk;
    data['golongan_produk'] = golonganProduk;
    data['merk_produk'] = merkProduk;
    data['deskripsi_produk'] = deskripsiProduk;
    data['berat_produk'] = beratProduk;
    data['harga_pokok'] = hargaPokok;
    data['multisatuan_jumlah'] = multisatuanJumlah;
    data['multisatuan_unit'] = multisatuanUnit;
    data['gambar1'] = gambar1;
    data['gambar2'] = gambar2;
    data['gambar3'] = gambar3;
    data['gambar4'] = gambar4;
    data['gambar5'] = gambar5;
    data['is_aktiva'] = isAktiva;
    data['kat1'] = kat1;
    data['kat1_slug'] = kat1Slug;
    data['kat2'] = kat2;
    data['kat2_slug'] = kat2Slug;
    data['kat3'] = kat3;
    data['kat3_slug'] = kat3Slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['gambar'] = gambar;
    if (stok != null) {
      data['stok'] = stok!.map((v) => v.toJson()).toList();
    }
    if (harga != null) {
      data['harga'] = harga!.map((v) => v.toJson()).toList();
    }
    data['rating'] = rating;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cabang_id'] = cabangId;
    data['cabang'] = cabang;
    data['stok'] = stok;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cabang_id'] = cabangId;
    data['cabang'] = cabang;
    data['harga'] = harga;
    data['harga_diskon'] = hargaDiskon;
    data['diskon'] = diskon;
    return data;
  }
}
