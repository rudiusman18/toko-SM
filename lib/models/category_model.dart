class CategoryModel {
  String? message;
  List<Data>? data;

  CategoryModel({this.message, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
  String? kat1;
  String? kat1Slug;
  List<Child>? child;

  Data({this.kat1, this.kat1Slug, this.child});

  Data.fromJson(Map<String, dynamic> json) {
    kat1 = json['kat1'];
    kat1Slug = json['kat1_slug'];
    if (json['child'] != null) {
      child = <Child>[];
      json['child'].forEach((v) {
        child!.add(Child.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kat1'] = kat1;
    data['kat1_slug'] = kat1Slug;
    if (child != null) {
      data['child'] = child!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child {
  String? kat2;
  String? kat1Slug;
  String? kat2Slug;
  List<Child1>? child1;

  Child({this.kat2, this.kat1Slug, this.kat2Slug, this.child1});

  Child.fromJson(Map<String, dynamic> json) {
    kat2 = json['kat2'];
    kat1Slug = json['kat1_slug'];
    kat2Slug = json['kat2_slug'];
    if (json['child'] != null) {
      child1 = <Child1>[];
      json['child'].forEach((v) {
        child1!.add(Child1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kat2'] = kat2;
    data['kat1_slug'] = kat1Slug;
    data['kat2_slug'] = kat2Slug;
    if (child1 != null) {
      data['child'] = child1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Child1 {
  String? kat3;
  String? kat1Slug;
  String? kat2Slug;
  String? kat3Slug;

  Child1({this.kat3, this.kat1Slug, this.kat2Slug, this.kat3Slug});

  Child1.fromJson(Map<String, dynamic> json) {
    kat3 = json['kat3'];
    kat1Slug = json['kat1_slug'];
    kat2Slug = json['kat2_slug'];
    kat3Slug = json['kat3_slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kat3'] = kat3;
    data['kat1_slug'] = kat1Slug;
    data['kat2_slug'] = kat2Slug;
    data['kat3_slug'] = kat3Slug;
    return data;
  }
}
