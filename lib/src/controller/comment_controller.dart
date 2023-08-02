import 'package:flutter/cupertino.dart';
import 'package:student_care_admin/src/controller/user_controller.dart';

import '../model/commentModel.dart';
import '../services/comment_service.dart';

class CommentsController extends ChangeNotifier{
  bool load = false;

  TextEditingController commentsCtrl = TextEditingController();
  List<Comments> commentList = [];
//  List<PostModel> postListSearchable = [];
  Future<List<Comments>> getAllPostComments(String postId)async{
    List<Comments> commentList2 = [];
    CommentService.getAllComments(postId: postId)!.listen((event) {
      commentList.clear();

      commentList2.clear();
      event.forEach((element) => commentList2!.add(element));

      print(commentList
      );
      notifyListeners();
     // onSearchForConsultants(searchString!);
      notifyListeners();

    });
    return commentList2;
  }

  Future createComment(String postId)async{
    load = true;
    notifyListeners();
    Comments comments = Comments(
      content:commentsCtrl.text.trim(),
      createdAt: DateTime.now(),
      name: userController.userModel!.userName,
      userId: userController.userModel!.userId,
      postId:postId,
    );

    await CommentService.createComment(comments);
    load = false;
    notifyListeners();
    commentsCtrl.clear();


  }
}