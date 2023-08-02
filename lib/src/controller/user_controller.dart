
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:student_care_admin/src/collections.dart';

import '../model/UserModel.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'central_state.dart';

class UserController extends ChangeNotifier{

 UserModel? userModel;
  init()async{
    centralState.startLoading();
    userModel= await AuthService().findUserById(FirebaseAuth
        .instance.currentUser
    !.uid);
    print('userrr $userModel');
    centralState.stopLoading();
    notifyListeners();
  }

  Future checkForAdminEmail(String email)async{
    try{
      QuerySnapshot querySnapshot = await Collections.admin.where("email", isEqualTo: email).get();
      if(querySnapshot.docs.isNotEmpty){
        return true;
      }
      return null;
    }catch(e){
      print(e.toString());
      return null;
    }


  }

}

UserController userController = UserController();