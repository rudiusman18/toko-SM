

import 'package:flutter/cupertino.dart';
import 'package:tokoSM/models/profile_model.dart';
import 'package:tokoSM/services/profile_service.dart';

class ProfileProvider with ChangeNotifier{

  ProfileModel _profileModel = ProfileModel();
  ProfileModel get profileModel => _profileModel;
  set profileModel(ProfileModel profileModel){
    _profileModel = profileModel;
    notifyListeners();
  }

  Future<bool>getProfile({required String token, required String userId,})async{
    try{
      ProfileModel profileModel = await ProfileService().retrieveProfile(token: token, userId: userId);
      _profileModel = profileModel;
      return true;
    }catch(e){
      print("ada error ketika mendapatkan profile $e");
      return false;
    }
  }

  Future<bool>updateProfile({required String token, required String userId, required int cabangId, required String username, required String namaLengkap, required String email, required String telp, required String alamat, required String wilayah, required String tglLahir, required String jenisKelamin,})async{
    try{
      await ProfileService().updateProfile(token: token, userId: userId, cabangId: cabangId, username: username, namaLengkap: namaLengkap, email: email, telp: telp, alamat: alamat, wilayah: wilayah, tglLahir: tglLahir, jenisKelamin: jenisKelamin);
      return true;
    }
    catch(e){
      print("update profile mengalami kegagalan: $e");
      return false;
    }
}

}