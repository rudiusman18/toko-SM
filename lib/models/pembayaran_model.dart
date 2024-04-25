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
  int? id;
  int? cabangId;
  String? namaBank;
  String? logoBank;
  String? noRekening;

  Data({this.id, this.cabangId, this.namaBank, this.logoBank, this.noRekening});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    namaBank = json['nama_bank'];
    logoBank = json['logo_bank'];
    noRekening = json['no_rekening'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['cabang_id'] = cabangId;
    data['nama_bank'] = namaBank;
    data['logo_bank'] = logoBank;
    data['no_rekening'] = noRekening;
    return data;
  }
}
