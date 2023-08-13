import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{

  String? content;
 List<String>? picture;
  DateTime? createdAt;
  String?status;
  String?postId;
  String? subStatus;
  bool? isAnonymous;

  Poster? poster;
  Poster? anonymousPoster;
  PostModel({this.poster,this.anonymousPoster,this.createdAt,this.status,this.content,this.picture,this.postId,this.subStatus, this.isAnonymous});

  PostModel.fromJson(Map<String, dynamic> data){
    content = data['content'];
    picture =List.from(data['pics']);
    isAnonymous=data['isAnonymous']??false;
    postId= data['postId'];
    createdAt =Timestamp(data['createdAt'].seconds,data['createdAt'].nanoseconds).toDate();
    status=data['status'];
    poster=Poster.fromJson(data['poster']);
    subStatus=data['subStatus'];
    anonymousPoster=data['anonymousPoster'];
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> data= {};
    data['content']=content;
    data['postId']= postId;
    data['createdAt']= createdAt;
    data['status']= status;
    data['poster']= poster!.toJson();
    data['subStatus']=subStatus;
    data['isAnonymous']=isAnonymous;
    data['anonymousPoster']=anonymousPoster;
    data['pics']=picture;
    return data;
  }

}


class Poster{
  String? username;
  String? userId;
  String? email;
  String? profilePic;
  Poster({this.userId,this.email,this.username,this.profilePic});
  Poster.fromJson(Map<String,dynamic> data){
    username= data['username'];
    userId=data['userId'];
    email=data['email'];
    profilePic = data['profilePic'];
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> data ={};
    data['username']=username;
    data['userId']= userId;
    data['email']=email;
    data['profilePic']=profilePic;
    return  data;
  }
}


class Status{
  //static String resolved='resolved';
  static String pending='pending';
  static String inReview='In Review';
  static String approved ='Approved';
}
class SubStatus{
  static String pending='pending';
  static String inReview='In Review';
  static String approved ='Approved';
}
