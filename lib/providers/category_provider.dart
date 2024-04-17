import 'package:flutter/material.dart';
import 'package:tokoSM/models/category_model.dart';
import 'package:tokoSM/services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  CategoryModel _categoryModel = CategoryModel();
  CategoryModel get categoryModel => _categoryModel;

  set categoryModel(CategoryModel categoryModel) {
    _categoryModel = categoryModel;
    notifyListeners();
  }

  Future<bool> getCategory({required String token}) async {
    try {
      CategoryModel category = await CategoryService().category(
        token: token,
      );
      _categoryModel = category;
      return true;
    } catch (e) {
      return false;
    }
  }
}
