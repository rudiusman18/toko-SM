
import 'package:flutter/cupertino.dart';
import 'package:tokoSM/models/kurir_model.dart';
import 'package:tokoSM/services/kurir_service.dart';

class KurirProvider with ChangeNotifier{
  KurirModel _kurirModel = KurirModel();
  KurirModel get kurirModel => _kurirModel;
  set kurirModel(KurirModel kurirMdel){
    _kurirModel = kurirModel;
    notifyListeners();
  }

  Future<bool> getKurir({required String token, required String cabangId})async{
    try{
      KurirModel kurirModel = await KurirService().retrieveKurir(token: token, cabangId: cabangId);
      _kurirModel = kurirModel;
      return true;
    }
    catch(e){
     return false;
    }
  }

}