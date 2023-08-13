import 'package:flutter/cupertino.dart';
import 'package:student_care_admin/src/controller/postController.dart';
import 'package:student_care_admin/src/controller/user_controller.dart';
import 'package:student_care_admin/src/model/PostModel.dart';

import '../model/UserModel.dart';
import '../model/commentModel.dart';
import '../services/comment_service.dart';
import '../utils/reusable_widget.dart';

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

  Future createComment(PostModel postModel,List<UserModel> userList)async{
    load = true;
    notifyListeners();
    Comments comments = Comments(
      content:commentsCtrl.text.trim(),
      createdAt: DateTime.now(),
      name: userController.userModel!.userName,
      userId: userController.userModel!.userId,
      postId:postModel.postId,
    );

    await CommentService.createComment(comments);

    showToast("Notifying users...");
    for(var users in userList){
      if(users.email != userController.userModel!.email){

        print('0000');
        await PostController().sendEmail("Hello ${users.userName} An admin  on CCU Welfare Care made a comment on '${postModel.content}' ",email: users.email);

      }
      }
    load = false;
    notifyListeners();
    commentsCtrl.clear();


  }
}