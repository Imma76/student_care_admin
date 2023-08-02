import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseCloud= FirebaseFirestore.instance;
class Collections{

  static CollectionReference users = firebaseCloud.collection("users");
  static CollectionReference post = firebaseCloud.collection("post");
  static CollectionReference comments = firebaseCloud.collection("comments");
  static CollectionReference admin = firebaseCloud.collection("admin");
}