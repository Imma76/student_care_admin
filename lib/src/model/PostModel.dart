import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{

  String? content;
 List<String>? picture;
  DateTime? createdAt;
  String?status;
  String?postId;

  Poster? poster;
  PostModel({this.poster,this.createdAt,this.status,this.content,this.picture,this.postId});

  PostModel.fromJson(Map<String, dynamic> data){
    content = data['content'];
    picture =List.from(data['pics']);
    postId= data['postId'];
    createdAt =Timestamp(data['createdAt'].seconds,data['createdAt'].nanoseconds).toDate();
    status=data['status'];
    poster=Poster.fromJson(data['poster']);
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> data= {};
    data['content']=content;
    data['postId']= postId;
    data['createdAt']= createdAt;
    data['status']= status;
    data['poster']= poster!.toJson();

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