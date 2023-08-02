import 'package:cloud_firestore/cloud_firestore.dart';

class Comments{
  String? name;
  String? content;
  DateTime? createdAt;
  String? userId;
  String?postId;

  Comments({this.createdAt,this.content,this.name,this.userId,this.postId});
  Comments.fromJson(Map<String,dynamic> data){
    name= data['name'];
    createdAt=Timestamp(data['createdAt'].seconds,data['createdAt'].nanoseconds).toDate();
    content = data['content'];
    userId = data['userId'];

    postId = data['postId'];
  }

  toJson(){
    Map<String,dynamic> data={};
    data['name'] =name;
    data['content']=content;
    data['userId']=userId;
    data['postId']= postId;
    data['createdAt']= createdAt;
    return data;
  }
}