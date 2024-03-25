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
  String? kodeProduk;
  String? barcodeProduk;
  String? namaProduk;
  String? satuanProduk;
  String? golonganProduk;
  String? merkProduk;
  String? deskripsiProduk;
  String? beratProduk;
  String? hargaPokok;
  String? multisatuanJumlah;
  String? multisatuanUnit;
  String? gambar1;
  String? gambar2;
  String? gambar3;
  String? gambar4;
  String? gambar5;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Stok>? stok;
  List<Harga>? harga;

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
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.stok,
      this.harga});

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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (stok != null) {
      data['stok'] = stok!.map((v) => v.toJson()).toList();
    }
    if (harga != null) {
      data['harga'] = harga!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stok {
  String? cabang;
  int? stok;

  Stok({this.cabang, this.stok});

  Stok.fromJson(Map<String, dynamic> json) {
    cabang = json['cabang'];
    stok = json['stok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cabang'] = this.cabang;
    data['stok'] = this.stok;
    return data;
  }
}

class Harga {
  String? cabang;
  int? harga;
  int? hargaDiskon;
  int? diskon;

  Harga({this.cabang, this.harga, this.hargaDiskon, this.diskon});

  Harga.fromJson(Map<String, dynamic> json) {
    cabang = json['cabang'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
    diskon = json['diskon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cabang'] = this.cabang;
    data['harga'] = this.harga;
    data['harga_diskon'] = this.hargaDiskon;
    data['diskon'] = this.diskon;
    return data;
  }
}
