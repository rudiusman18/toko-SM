// ignore_for_file: prefer_collection_literals

class DetailStatusModel {
  String? message;
  List<Data>? data;

  DetailStatusModel({this.message, this.data});

  DetailStatusModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? noInvoice;
  int? status;
  String? keterangan;
  String? deskripsi;
  String? createdAt;
  String? date;
  String? time;

  Data(
      {this.sId,
      this.noInvoice,
      this.status,
      this.keterangan,
      this.deskripsi,
      this.createdAt,
      this.date,
      this.time});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    noInvoice = json['no_invoice'];
    status = json['status'];
    keterangan = json['keterangan'];
    deskripsi = json['deskripsi'];
    createdAt = json['created_at'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['no_invoice'] = noInvoice;
    data['status'] = status;
    data['keterangan'] = keterangan;
    data['deskripsi'] = deskripsi;
    data['created_at'] = createdAt;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
