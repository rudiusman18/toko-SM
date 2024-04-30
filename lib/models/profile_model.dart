class ProfileModel {
  String? message;
  Data? data;

  ProfileModel({this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  int? cabangId;
  int? salesId;
  int? kategoriPelangganId;
  String? username;
  String? password;
  String? namaPelanggan;
  String? tglLahirPelanggan;
  String? jenisKelaminPelanggan;
  String? telpPelanggan;
  String? emailPelanggan;
  String? alamatPelanggan;
  String? provinsi;
  String? kabkota;
  String? kecamatan;
  String? kelurahan;
  String? lat;
  String? lon;
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
        this.telpPelanggan,
        this.emailPelanggan,
        this.alamatPelanggan,
        this.provinsi,
        this.kabkota,
        this.kecamatan,
        this.kelurahan,
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
    telpPelanggan = json['telp_pelanggan'];
    emailPelanggan = json['email_pelanggan'];
    alamatPelanggan = json['alamat_pelanggan'];
    provinsi = json['provinsi'];
    kabkota = json['kabkota'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
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
    data['telp_pelanggan'] = telpPelanggan;
    data['email_pelanggan'] = emailPelanggan;
    data['alamat_pelanggan'] = alamatPelanggan;
    data['provinsi'] = provinsi;
    data['kabkota'] = kabkota;
    data['kecamatan'] = kecamatan;
    data['kelurahan'] = kelurahan;
    data['lat'] = lat;
    data['lon'] = lon;
    data['nama_cabang'] = namaCabang;
    return data;
  }
}
