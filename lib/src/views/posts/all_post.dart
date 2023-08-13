// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:student_care_admin/src/views/image_view.dart';

import '../../controller/comment_controller.dart';
import '../../controller/postController.dart';
import '../../model/PostModel.dart';
import '../../model/commentModel.dart';
import '../../provider/all_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/loader.dart';
import 'new_post.dart';

class AllPost extends ConsumerStatefulWidget {
  const AllPost({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<AllPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(postProvider);
    ref.read(postProvider).getAllPost();
    ref.read(postProvider).getAllUsers();
    ref.read(commentProvider);


  }

  @override
  Widget build(BuildContext context) {


    PostController postController = ref.watch(postProvider);
    return Scaffold(


      floatingActionButton:FloatingActionButton(onPressed: (){

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewPost()));

      },backgroundColor: AppTheme.primary,child: const Icon(Icons.add,),),
      appBar:AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_ios_rounded,color: AppTheme.black,),),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //leadingWidth: 300,
        title: Text('  Timeline',style: GoogleFonts.poppins(fontSize:30 ,color: AppTheme.black),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color:AppTheme.white,
                  borderRadius: BorderRadius.circular(20)),
              height: 200,
              width: double.infinity,
              child: GestureDetector(
                onTap: (){
                  postController.getAllPost();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('${postController.postList.length}',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),

                    Center(child: Text('Total Post(s)',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),
                       Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          postController.getAllEditedPost(Status.pending);
                          //postController.getAllEditedPost(Status.pending);

                        },
                        child: Column(
                          children: [
                            Center(child: Text('${postController.pending}',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),
                            Center(child: Text('Pending',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),

                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          postController.getAllEditedPost(Status.inReview);
                        },
                        child: Column(
                          children: [
                            Center(child: Text('${postController.inReview}',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),
                            Center(child: Text('In Review',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),

                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          postController.getAllEditedPost(Status.approved);
                        },
                        child: Column(
                          children: [
                            Center(child: Text('${postController.approved}',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),
                            Center(child: Text('Approved',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),

                          ],
                        ),
                      ),

                    ],
                  )
                  ],
                ),
              ),

            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: postController.postList.length,
                itemBuilder: (context,index){
                  return  Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.
                      children: const [
                        // A SlidableAction can have an icon and/or a label.
                        // SlidableAction(
                        //   onPressed: doNothing,
                        //   backgroundColor: Color(0xFFFE4A49),
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.delete,
                        //   label: 'Delete',
                        // ),
                        // SlidableAction(
                        //   onPressed: doNothing,
                        //   backgroundColor: Color(0xFF21B7CA),
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.share,
                        //   label: 'Share',
                        // ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane:  ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed:(context)async{
                            await  postController.deletePost(postController.postList[index].postId!);
                          },
                          backgroundColor: const Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'delete',
                        ),
                        // SlidableAction(
                        //   onPressed: doNothing,
                        //   backgroundColor: Color(0xFF0392CF),
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.save,
                        //   label: 'Save',
                        // ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child:  PostWidget(postModel: postController.postList[index],),
                  );


                }),
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
    ref.read(postProvider).getAllUsers();

  }
  @override
  Widget build(BuildContext context) {
    CommentsController commentsController= ref.watch(commentProvider);
    PostController postController = ref.watch(postProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // constraints: const BoxConstraints
        //   (minHeight: 100, maxHeight: 300.0),
       height: MediaQuery.of(context).size.height/5,
        // padding: const EdgeInsets.all(8.0),

    // height: double.parse(widget.postModel!.content!.length!.toString()),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Gap(10),
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
                    Text(DateFormat('MMMM d, h:mm a').format(widget.postModel!.createdAt!),style: GoogleFonts.poppins(fontSize:7 ),),


                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: ()async{

                    showDialog(context: context, builder: (context) {
                      return StatefulBuilder(
                          builder: (context,widgets) {
                            return Dialog(
                              backgroundColor:
                              Colors.white,

                              child: Container(
                                decoration: BoxDecoration(color:
                                Colors.white, borderRadius: BorderRadius.circular(10)),
                                height:
                                200,
                                width: 382,

                                child:postController.load?Indicator2(): Column(
                                  children: [
                                    Gap(22),
                                    GestureDetector(
                                      onTap: ()async{
                                        widgets(() {

                                        });

                                        if(widget.postModel!.status != Status.pending){
                                          widget.postModel!.status= Status.pending;
                                          await postController.updatePostStatus(widget.postModel!);

                                        }Navigator.pop(context);
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text('Pending',textAlign: TextAlign.center,
                                            style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        widgets(() {

                                        });
                                        if(widget.postModel!.status != Status.inReview){
                                          widget.postModel!.status= Status.inReview;
                                          await postController.updatePostStatus(widget.postModel!);



                                        }Navigator.pop(context);
                                        // for(var users in postController.userList){
                                        //   await postController.sendEmail("Hello ${users.userName} An admin  on CCU Welfare Care has changed the status of '${widget.postModel!.content}' to ${widget.postModel!.status}",email: users.email);
                                        // }
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text('In Review',textAlign: TextAlign.center,
                                            style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        widgets(() {

                                        });
                                        if(widget.postModel!.status != Status.approved){
                                          widget.postModel!.status= Status.approved;
                                          if(postController.isAnonymous){
                                            widget.postModel!.anonymousPoster =Poster(
                                              userId: widget.postModel!.poster!.userId,
                                              email:"anonymous",
                                              username: "anonymous",
                                              profilePic: null,
                                            );
                                          }
                                          await postController.updatePostStatus(widget.postModel!);

                                        }Navigator.pop(context);
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text('Approved',textAlign: TextAlign.center,
                                            style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ),

                            );
                          }
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius
                        .circular(5),  color: widget.postModel!.status==Status.pending
                        ?Colors.grey:widget.postModel!.status==Status.inReview?Colors.red:Colors.green,),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('${widget.postModel!.status}',style: GoogleFonts.poppins(fontSize:10 ),),
                        )),
                  ),
                ),
              ],
            ),
            const Gap(6),


            GestureDetector(

                onTap: (){
                  showModalBottomSheet(context: context, builder: (context)=>StatefulBuilder(
                    builder: (context,widgets) {
                      return Container(child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('${widget.postModel!.content}',style: GoogleFonts.poppins(fontSize: 16)),
                          ),
                          if(widget.postModel!.isAnonymous!)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline),Gap(5),
                                      Text('The poster is requesting the post to be anonymous')
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('approve post anonymously', style: GoogleFonts.lora(),),const Spacer(),
                                      Switch(value: postController.isAnonymous, onChanged: (value){
                                        postController.changePostVisibility(value);
                                        widgets((){

                                        });
                                      },activeColor: AppTheme.primary,),
                                    ],
                                  ),
                                ),


                              ],
                            ),

                          if(widget.postModel!.picture!.isNotEmpty)
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: widget.postModel!.picture!.length,
                                  itemBuilder: (context,index)=>Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageView(imageUrl: widget.postModel!.picture![index],))),
                                      child: CachedNetworkImage(

                                        imageUrl: widget.postModel!.picture![index],
                                        //  width: 200,height: 100,
                                        fit: BoxFit.contain,),
                                    ),
                                  )),
                            ),
                          Row(
                            children: [
                              Text('Status', style: GoogleFonts.lora(),),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(onPressed: ()async{

                                    showDialog(context: context, builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context,widgets) {
                                            return Dialog(
                                              backgroundColor:
                                              Colors.white,

                                              child: Container(
                                                decoration: BoxDecoration(color:
                                                Colors.white, borderRadius: BorderRadius.circular(10)),
                                                height:
                                                200,
                                                width: 382,

                                                child:postController.load?Indicator2(): Column(
                                                  children: [
                                                    Gap(22),
                                                    GestureDetector(
                                                      onTap: ()async{
                                                        widgets(() {

                                                        });

                                                        if(widget.postModel!.status != Status.pending){
                                                          widget.postModel!.status= Status.pending;
                                                          await postController.updatePostStatus(widget.postModel!);

                                                        }Navigator.pop(context);
                                                      },
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Center(
                                                          child: Text('Pending',textAlign: TextAlign.center,
                                                            style: GoogleFonts.dmSans(
                                                                color: Colors.black,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500),),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: ()async{
                                                        widgets(() {

                                                        });
                                                        if(widget.postModel!.status != Status.inReview){
                                                          widget.postModel!.status= Status.inReview;
                                                          await postController.updatePostStatus(widget.postModel!);



                                                        }Navigator.pop(context);
                                                        // for(var users in postController.userList){
                                                        //   await postController.sendEmail("Hello ${users.userName} An admin  on CCU Welfare Care has changed the status of '${widget.postModel!.content}' to ${widget.postModel!.status}",email: users.email);
                                                        // }
                                                      },
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Center(
                                                          child: Text('In Review',textAlign: TextAlign.center,
                                                            style: GoogleFonts.dmSans(
                                                                color: Colors.black,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500),),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: ()async{
                                                        widgets(() {

                                                        });
                                                        if(widget.postModel!.status != Status.approved){
                                                          widget.postModel!.status= Status.approved;
                                                          await postController.updatePostStatus(widget.postModel!);

                                                        }Navigator.pop(context);
                                                      },
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: Center(
                                                          child: Text('Approved',textAlign: TextAlign.center,
                                                            style: GoogleFonts.dmSans(
                                                                color: Colors.black,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500),),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                              ),

                                            );
                                          }
                                      );
                                    });
                                  },
                                    style: ElevatedButton.styleFrom(primary: widget.postModel!.status==Status.pending
                      ?Colors.grey:widget.postModel!.status==Status.inReview?Colors.red:Colors.green,
                                      fixedSize: const Size(100,30),
                                      minimumSize:  const Size(100,30),
                                      // minWidth: double.infinity,
                                    ),
                                    child: Text('${widget.postModel!.status}',style: GoogleFonts.lora(color: Colors.white),), ),
                                ),
                              ),
                            ],
                          ),
                          Gap(30),
                        ],
                      ));
                    }
                  ));
                },
                child: Text('${widget.postModel!.content}',overflow: TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: 16),)),
            if(widget.postModel!.picture!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.postModel!.picture!.length,
                    itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageView(imageUrl: widget.postModel!.picture![index],))),

                        child: CachedNetworkImage(

                            imageUrl: widget.postModel!.picture![index],
                        //  width: 200,height: 100,
                          fit: BoxFit.contain,),
                      ),
                    )),
              ),

           Gap(20),
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
                                        await  commentsController.createComment(widget.postModel!,postController.userList);
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
    );
  }
}