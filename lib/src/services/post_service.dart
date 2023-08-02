import 'package:cloud_firestore/cloud_firestore.dart';

import '../collections.dart';
import '../model/PostModel.dart';

class PostService{
  static Future createPost(PostModel postModel
      )async{
    try{
      await Collections.post.add(postModel.toJson());
      return true;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  static  Stream<List<PostModel>>? getAllPost( {String? orderBy = 'createdAt',
    bool? descending = true,
    var startAt,}){
    try{
      Query query =  Collections.post.orderBy("createdAt",descending: true);

      return query.snapshots()
          .map((snapShot) => snapShot.docs.map<PostModel>((postModel) {

        Map _temp = postModel.data() as Map<dynamic, dynamic>;
        _temp['postId'] = postModel.id;
        // //(_temp);
        return PostModel.fromJson(_temp as Map<String, dynamic>);
      }).toList());
    }catch(e){
      return null;
    }
  }

}