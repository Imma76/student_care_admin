import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../collections.dart';
import '../model/commentModel.dart';

class CommentService extends ChangeNotifier{
  static Future getAllComment()async{

  }
  static  Stream<List<Comments>>? getAllComments( {String? postId,
    bool? descending = true,
    var startAt,}){
    try{
      Query query =  Collections.comments.orderBy("createdAt",descending: false).where("postId",isEqualTo:postId);

      return query.snapshots()
          .map((snapShot) => snapShot.docs.map<Comments>((postModel) {

        Map _temp = postModel.data() as Map<dynamic, dynamic>;
        _temp['commentId'] = postModel.id;
        // //(_temp);
        return Comments.fromJson(_temp as Map<String, dynamic>);
      }).toList());
    }catch(e){
      return null;
    }
  }

  static Future createComment(Comments comment
      )async{
    try{
      await Collections.comments.add(comment.toJson());
      return true;
    }catch(e){
      return null;
    }
  }
}