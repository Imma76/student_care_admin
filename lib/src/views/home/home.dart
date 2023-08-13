// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_care_admin/src/views/users/all_users.dart';
import '../../controller/comment_controller.dart';
import '../../controller/postController.dart';
import '../../model/PostModel.dart';
import '../../model/commentModel.dart';
import '../../provider/all_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/loader.dart';
import '../authentication/welcome.dart';
import '../posts/all_post.dart';
import '../posts/new_post.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }
  @override
  Widget build(BuildContext context) {

  //  PostController postController = ref.watch(postProvider);
    return Scaffold(

      floatingActionButton:FloatingActionButton(onPressed: (){

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewPost()));

      },child: const Icon(Icons.add,),backgroundColor: AppTheme.primary,),
      appBar:AppBar(
        actions: [
          IconButton(icon:Icon(Icons.logout,color: AppTheme.greyMessageColor,),onPressed: ()async{
            await FirebaseAuth.instance.signOut();

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WelcomePage()), (route) => false);


          },)
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leadingWidth: 300,
        leading: Text('  Admin panel',style: GoogleFonts.poppins(fontSize:25 ,color: AppTheme.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllUsers()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),

                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Icon(Icons.people,size: 55,),
                  Gap(20),
                  Text('Users',style: GoogleFonts.poppins(fontSize:25 ,color: AppTheme.primary),),
                ],),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()=>  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllPost())),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),

                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.book_outlined,size: 55,),
                    const Gap(20),
                    Text('Posts',style: GoogleFonts.poppins(fontSize:25 ,color: AppTheme.primary),),
                  ],),
              ),
            ),
          )

        ],
      ),
    );
  }
}

class PostWidget extends ConsumerStatefulWidget {
  final PostModel?postModel;
  const PostWidget({
    Key? key,this.postModel
  }) : super(key: key);

  @override
  ConsumerState createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  List<Comments> commentList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(commentProvider);
    commentList.clear();
   ref.read(commentProvider).getAllPostComments(widget.postModel!.postId!).then((value) {
      commentList=value;
      return commentList;
    });
  }
  @override
  Widget build(BuildContext context) {
    CommentsController commentsController= ref.watch(commentProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 100,
        color: Colors.white,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius:15,child: Icon(Icons.person),),
                const Gap(10),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text('${widget.postModel!.poster!.username}',style: GoogleFonts.poppins(fontSize:10,fontWeight:

                    FontWeight.bold),),
                    Text('1 hour ago',style: GoogleFonts.poppins(fontSize:7 ),),


                  ],
                ),
                const Spacer(),
                Container(

                  decoration: BoxDecoration(borderRadius: BorderRadius
                      .circular(5),  color: Colors.grey,),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text('Pending',style: GoogleFonts.poppins(fontSize:10 ),),
                      )),
                ),
              ],
            ),
            const Gap(6),
            Text('${widget.postModel!.content}'),
            const Spacer(
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: ()async{
                  // await  commentsController.getAllPostComments(postModel!.postId!);
                  showModalBottomSheet(context: context, builder: (_)=> StatefulBuilder(
                      builder: (context,widgets) {
                        return Column(
                          children: [

                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount :commentList.length,
                                  itemBuilder: (context,index)=>CommentsTile(comments:
                                  commentList[index],)),
                            ),
                            //const Spacer(),
                            commentsController.load?const Indicator2():    Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:commentsController.commentsCtrl,
                                        decoration: const InputDecoration(
                                          hintText: 'Type your message...',
                                        ),
                                        // Add any necessary logic or controllers for the TextField here
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: ()async {
                                        widgets((){

                                        });
                                     //   await  commentsController.createComment(widget.postModel!);
                                        // Add your send message logic here

                                        widgets((){

                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(20),
                          ],
                        );
                      }
                  ));
                },
                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${commentList.length}'),
                    const Icon(Icons.comment,size:

                    15,),
                  ],
                ),
              ),
            )
          ],),
      ),
    );
  }
}




class CommentsTile extends ConsumerWidget {
  final Comments? comments;

  const CommentsTile({
    Key? key,this.comments
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 70,
        color: Colors.white,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius:15,child: Icon(Icons.person),),
                const Gap(10),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text('${comments!.name}',style: GoogleFonts.poppins(fontSize:10,fontWeight:

                    FontWeight.bold),),
                    Text('1 hour ago',style: GoogleFonts.poppins(fontSize:7 ),),


                  ],
                ),
                const Spacer(),

              ],
            ),
            const Gap(6),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('${comments!.content}'),
            ),
            const Spacer(
            ),

          ],),
      ),
    );;
  }
}