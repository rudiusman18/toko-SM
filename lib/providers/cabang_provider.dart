
import 'package:flutter/cupertino.dart';
import 'package:tokoSM/services/cabang_service.dart';

import '../models/cabang_model.dart';

class CabangProvider with ChangeNotifier{
  CabangModel _cabangModel = CabangModel();
  CabangModel get cabangModel => _cabangModel;
  set cabangModel(CabangModel cabangModel){
    _cabangModel = cabangModel;
    notifyListeners();
  }

  Future<bool> getCabang({required String token})async{
    try{
      CabangModel cabangModel = await CabangService().retrieveDataCabang(token: token);
      _cabangModel = cabangModel;
      return true;
    }catch(e){
      return false;
    }
  }
}