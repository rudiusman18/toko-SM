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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? status;
  String? deskripsi;
  String? date;
  String? time;

  Data({this.status, this.deskripsi, this.date, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    deskripsi = json['deskripsi'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['deskripsi'] = deskripsi;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
