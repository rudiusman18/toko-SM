class ProductModel {
  String? message;
  List<Data>? data;

  ProductModel({this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
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
  int? produkKategoriId;
  String? kodeProduk;
  String? barcodeProduk;
  String? namaProduk;
  String? satuanProduk;
  String? golonganProduk;
  String? merkProduk;
  String? deskripsiProduk;
  int? beratProduk;
  int? hargaPokok;
  String? multisatuanJumlah;
  String? multisatuanUnit;
  String? gambar1;
  String? gambar2;
  String? gambar3;
  String? gambar4;
  String? gambar5;
  int? hargaMember;
  int? diskon;
  int? harga;
  int? hargaDiskon;

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
      this.hargaMember,
      this.diskon,
      this.harga,
      this.hargaDiskon});

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
    hargaMember = json['harga_member'];
    diskon = json['diskon'];
    harga = json['harga'];
    hargaDiskon = json['harga_diskon'];
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
    data['harga_member'] = hargaMember;
    data['diskon'] = diskon;
    data['harga'] = harga;
    data['harga_diskon'] = hargaDiskon;
    return data;
  }
}
