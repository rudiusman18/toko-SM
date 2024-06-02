class LoginModel {
  String? token;
  Data? data;

  LoginModel({this.token, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? cabangId;
  String? salesId;
  int? kategoriPelangganId;
  String? username;
  String? password;
  String? namaPelanggan;
  String? tglLahirPelanggan;
  String? jenisKelaminPelanggan;
  String? alamatPelanggan;
  String? telpPelanggan;
  String? emailPelanggan;
  double? lat;
  double? lon;
  String? namaCabang;

  Data(
      {this.id,
      this.cabangId,
      this.salesId,
      this.kategoriPelangganId,
      this.username,
      this.password,
      this.namaPelanggan,
      this.tglLahirPelanggan,
      this.jenisKelaminPelanggan,
      this.alamatPelanggan,
      this.telpPelanggan,
      this.emailPelanggan,
      this.lat,
      this.lon,
      this.namaCabang});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cabangId = json['cabang_id'];
    salesId = json['sales_id'];
    kategoriPelangganId = json['kategori_pelanggan_id'];
    username = json['username'];
    password = json['password'];
    namaPelanggan = json['nama_pelanggan'];
    tglLahirPelanggan = json['tgl_lahir_pelanggan'];
    jenisKelaminPelanggan = json['jenis_kelamin_pelanggan'];
    alamatPelanggan = json['alamat_pelanggan'];
    telpPelanggan = json['telp_pelanggan'];
    emailPelanggan = json['email_pelanggan'];
    lat = json['lat'];
    lon = json['lon'];
    namaCabang = json['nama_cabang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cabang_id'] = cabangId;
    data['sales_id'] = salesId;
    data['kategori_pelanggan_id'] = kategoriPelangganId;
    data['username'] = username;
    data['password'] = password;
    data['nama_pelanggan'] = namaPelanggan;
    data['tgl_lahir_pelanggan'] = tglLahirPelanggan;
    data['jenis_kelamin_pelanggan'] = jenisKelaminPelanggan;
    data['alamat_pelanggan'] = alamatPelanggan;
    data['telp_pelanggan'] = telpPelanggan;
    data['email_pelanggan'] = emailPelanggan;
    data['lat'] = lat;
    data['lon'] = lon;
    data['nama_cabang'] = this.namaCabang;
    return data;
  }
}
