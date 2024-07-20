// ignore_for_file: prefer_collection_literals

class PembayaranModel {
  String? message;
  List<Data>? data;

  PembayaranModel({this.message, this.data});

  PembayaranModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? kategori;
  List<Child>? child;

  Data({this.kategori, this.child});

  Data.fromJson(Map<String, dynamic> json) {
    kategori = json['kategori'];
    if (json['child'] != null) {
      child = <Child>[];
      json['child'].forEach((v) {
        child!.add(Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['kategori'] = kategori;
    if (child != null) {
      data['child'] = child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String? metode;
  String? nama;
  String? image;
  String? kode;

  Child({this.metode, this.nama, this.image});

  Child.fromJson(Map<String, dynamic> json) {
    metode = json['metode'];
    nama = json['nama'];
    image = json['image'];
    kode = json['kode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['metode'] = metode;
    data['nama'] = nama;
    data['image'] = image;
    data['kode'] = kode;
    return data;
  }
}
