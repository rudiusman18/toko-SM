import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier{
  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  set isFavorite(bool favorite){
    _isFavorite = favorite;
    notifyListeners();
  }
}