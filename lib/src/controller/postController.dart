import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:student_care_admin/src/controller/user_controller.dart';
import 'package:http/http.dart'as http;
import '../../main.dart';
import '../collections.dart';
import '../model/PostModel.dart';
import '../model/UserModel.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import '../utils/reusable_widget.dart';
import 'image_controller.dart';

class PostController extends ChangeNotifier{

  TextEditingController postController = TextEditingController();
  bool load = false;
  bool isAnonymous = false;

  changePostVisibility(bool newValue){
    isAnonymous = newValue;
    notifyListeners();
  }
  Future createPost(ImageController imageController)async{
load = true;
notifyListeners();
    if(imageController.imageFiles.isNotEmpty){
      await imageController.uploadImage();
    }
    Poster poster= Poster(
      userId: userController.userModel!.userId,
      email: userController.userModel!.email,
      username: userController.userModel!.userName,
      profilePic: userController.userModel!.profilePicture,
    );
Poster anonymousPoster= Poster(
  userId: userController.userModel!.userId,
  email:"anonymous",
  username: "anonymous",
  profilePic: null,
);
    PostModel post = PostModel(
      createdAt: DateTime.now(),
      status: PostStatus.pending,
      content: postController.text.trim(),
      picture:imageController.imageUrlList,
      poster:isAnonymous?anonymousPoster:poster,
    );
    final result = await PostService.createPost(post);
    if(result == null){
      load = true;
      notifyListeners();
      showToast("Unable to create post");
    }

showToast("Notifying users...");
for(var users in userList){
  await sendEmail("Hello ${users.userName} An admin  on CCU Welfare Care has made a new post on CCU Welfare Care App ",email: users.email);
}
load = false;
notifyListeners();
postController.clear();
imageController.imageUrlList.clear();
imageController.imageFiles.clear();
Navigator.pop(navigatorKey.currentState!.context);
Alert(
  context: navigatorKey.currentState!.context,
  type: AlertType.success,
  title: "",
  desc: "Post created successfully",
  buttons: [
    DialogButton(
      color: AppTheme.primary,
      child: Text(
        "Great",
        style: TextStyle(color: AppTheme.white, fontSize: 20),
      ),
      onPressed: () => Navigator.pop(navigatorKey.currentState!.context),
      width: 120,
    )
  ],
).show();
  }

  getAllConsultant(){

  }
  List<PostModel> postList = [];
  List<PostModel> postList2 = [];
  List<PostModel> postListSearchable = [];
  String? searchString = '';
  int inReview = 0;
  int approved=0;
  int pending= 0;

  getEditedList(String status){
    List<PostModel>newPostList = postList.where((element) => element.status==status).toList();
    postList=newPostList;
  }
  getAllPost()async{
    PostService.getAllPost()!.listen((event) {
      postList.clear();
      postList2.clear();
      inReview=0;
      approved=0;
      pending=0;
      event.forEach((element) {
        if(element.status==Status.approved){
          approved++;
          notifyListeners();
        }

        if(element.status==Status.pending){
          pending++;
          notifyListeners();
        }


        if(element.status
        ==Status.inReview){
          inReview++;
          notifyListeners();
        }
        postList!.add(element);
        postList2!.add(element);
      });
      print(postList);
      notifyListeners();
      onSearchForConsultants(searchString!);
      notifyListeners();

    });
  }

  getAllEditedPost(String status)async{
    PostService.getAllEditedPost(status:status
    )!.listen((event) {
      postList2.clear();
      inReview=0;
      approved=0;
      pending=0;
      event.forEach((element) {
        if(element.status==Status.approved){
          approved++;
          notifyListeners();
        }

        if(element.status==Status.pending){
          pending++;
          notifyListeners();
        }


        if(element.status
            ==Status.inReview){
          inReview++;
          notifyListeners();
        }
       // postList!.add(element);
        postList2!.add(element);
      });
      print(postList);
      notifyListeners();
      onSearchForConsultants(searchString!);
      notifyListeners();

    });
  }

  onSearchForConsultants(String search) {
    searchString = search.toLowerCase();
    notifyListeners();

    postListSearchable.clear();
    if (searchString == '' ||  searchString == null) {
      print(postList);
      postList!.forEach(
              (PostModel element) =>postListSearchable.add(element));
      notifyListeners();
    } else {
      postList
      !.forEach((PostModel? consultantModel) {

        // if (consultantModel
        // !.firstName!
        //     .toLowerCase()
        //     .contains(searchString!) || consultantModel!.lastName!
        //     .toLowerCase()
        //     .contains(searchString!)) {
        //   consultantListSearchable.add(consultantModel!);
        //   notifyListeners();
        // }

      });
    }
  }


  Future deletePost(String id)async{
    load = true;
    notifyListeners();
    try{
      await Collections.post.doc(id).delete();
      load =false;
      notifyListeners();
    }catch(e){
      load =false;
      notifyListeners();
      showToast("unable to delete post");
    }


  }
  Future updatePostStatus(PostModel postModel)async{
    load = true;
    notifyListeners();
    await Collections.post.doc(postModel.postId).update(postModel.toJson());

    showToast("Notifying user...");
    //for(var users in userList){
      await sendEmail("Hello ${postModel.poster!.username} An admin  on CCU Welfare Care has changed the status of '${postModel.content}' to ${postModel.status!.toUpperCase()}",email: postModel.poster!.email);
    //}
    load = false;
    notifyListeners();
    showToast("Status updated successfully");

  }
   Future sendEmail(String message,{ String? email })async {
    try {
      final response = await http.post(
          Uri.parse('https://email-service-fsmn.onrender.com/mail'), body: {
        "name": "CCU Welfare Care",
        "receiver": email!,
        "message": "${message}",
        "sender": "Consultant@gmail.com"
      });
      print(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

  List<UserModel> userList = [];
  Future getAllUsers()async{

    UserService.getAllUsers()!.listen((event) {
      userList.clear();

      event.forEach((element) => userList!.add(element));

      print(userList
      );
      notifyListeners();
      // onSearchForConsultants(searchString!);
      notifyListeners();

    });

  }
}



class PostStatus {
  static String pending ='pending';
  static String inReview= 'inReview';
  static String resolved = 'resolved';
}