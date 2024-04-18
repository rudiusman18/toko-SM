class SuggestionModel {
  String? message;
  List<String>? data;

  SuggestionModel({this.message, this.data});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}