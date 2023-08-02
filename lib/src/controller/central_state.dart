
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:student_care_admin/src/controller/user_controller.dart';

//import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';


class CentralState extends ChangeNotifier{
  User? user;

  bool isUserPresent = false;
  bool isAppLoading=false;
  bool isPhoneVerified=false;
  bool? isFirstTime = true;

  startLoading(){

    isAppLoading=true;
    notifyListeners();
  }

  void stopLoading(){

    isAppLoading = false;
    notifyListeners();
  }

  // void userData(UserModel newUserModel){
  //   userModel= newUserModel;
  //   notifyListeners();
  // }


  void setFirstTime()async{
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool("isFirstTime", false);
  }

  getIsUserFirstTime()async{
    // final prefs = await SharedPreferences.getInstance();
    //
    // isFirstTime = prefs.getBool("isFirstTime")?? true;
    // notifyListeners();
  }



  void initializeApp()async{
    await getIsUserFirstTime();
    isAppLoading = true;
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {

      if (firebaseUser != null) {
        isAppLoading = true;
        user = firebaseUser;
        notifyListeners();
        print(user);
        isUserPresent = (user != null);
        print(isUserPresent);
        notifyListeners();
      await userController.init();

        isAppLoading = false;
        notifyListeners();

      } else{
        debugPrint('user is null prod');
        isUserPresent = false;
        user = null;
        isAppLoading = false;
        notifyListeners();
        //     Navigator.pushNamedAndRemoveUntil(navigatorKey!.currentContext!, LoginScreen.id, (route) => false);


      }

      // await Future.delayed(Duration(seconds: 3),(){
      //
      //   isUserPresent =  false;
      //   notifyListeners();
      //   print('iiiiii');
      //
      // });

    });
  }
  void logOut()async{
    await  FirebaseAuth.instance.signOut();
   // Navigator.pushNamedAndRemoveUntil(navigatorKey!.currentContext!, LoginScreen.id, (route) => false);

  }
}

CentralState centralState =new CentralState();