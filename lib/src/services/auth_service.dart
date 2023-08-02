

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../collections.dart';
import '../model/UserModel.dart';
import '../utils/error_codes.dart';
import '../utils/reusable_widget.dart';

class AuthService{
  Future signIn({String? email,String? password})async{
    try{

      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.toString(), password: password.toString());
      return user.user;
    }on SocketException{
      return false;
    }on FirebaseAuthException catch(e){
      showToast(ErrorCodes.getFirebaseErrorMessage(e));
      return false;

    } catch(e){
      print(e.toString());
      return false;
    }
  }
  Future resetPassword({String? email,})async{
    try{

     await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      return true;
    }on SocketException{
      return false;
    }on FirebaseAuthException catch(e){
      showToast(ErrorCodes.getFirebaseErrorMessage(e));
      return false;
    } catch(e){
      print(e.toString());
      return false;
    }
  }


  Future createUser(UserModel userModel)async{
    try{
      final user = await Collections.users.doc(userModel.userId).set(userModel.toJson());
      return true;
    }on SocketException {
      return null;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signUp({String? email,String? password})async{
    try{

      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
      return user.user;
    }on SocketException{
      return false;
    } on FirebaseAuthException catch(e){
     showToast(ErrorCodes.getFirebaseErrorMessage(e));
  }catch(e){
      print(e.toString());
      return false;
    }
  }

  Future findUserByEmail(String email)async{
    try{
      QuerySnapshot
      data = await Collections.users.get();
      if(data.docs.isEmpty){
        return false;
      }
      return UserModel.fromJson(data.docs[0].data() as Map<String,dynamic>);

    }on SocketException{
      return false;
    } catch(e){
      return false;
    }
  }
  Future findUserById(String id)async{
    try{
      DocumentSnapshot
      data = await Collections.users.doc(id).get();
      if(data.exists){
        Map<String,dynamic> json = data.data() as Map<String,dynamic>;
        json['userId']=id;
        return UserModel.fromJson(json);
      }
      return false;

    }on SocketException{
      return false;
    } catch(e){
      return false;
    }
  }
}