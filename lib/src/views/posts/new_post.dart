import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../provider/all_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/loader.dart';
import '../../utils/reusable_widget.dart';


class NewPost extends ConsumerStatefulWidget {
  static const route = 'report_form';
  const NewPost({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ReportFormState();
}

class _ReportFormState extends ConsumerState<NewPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final postController = ref.read(postProvider);
  }
  @override
  Widget build(BuildContext context) {

    final postController = ref.watch(postProvider);
    final imageController = ref.watch(imageProvider);
    return SafeArea(
      child:  Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Create post',style:GoogleFonts.lora(color: Colors.black),),
            backgroundColor: Colors.transparent,elevation: 0,actions: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon:const Icon(Icons.close,color: Colors.black,))
          ],),

          body: postController.load?const Indicator2(): Padding(
            padding: const EdgeInsets.only(left:12.0,right: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                   TextField(
                    controller: postController.postController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(borderSide: BorderSide(color:  AppTheme.primary)),
                      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:  AppTheme.primary)),
                      hintText: 'Tell us whats happening...',
                      border: OutlineInputBorder(borderSide: BorderSide(color:  AppTheme.primary)),
                    ),),
                  const Gap(10),
                  Text('Attach photos',style: GoogleFonts.lora()),
                  const Gap(10),
                  Row(
                    children: [
                      MediaPicker(onTap: (){
                        imageController.pickImage();
                      },),
                      Expanded(
                        child: Container(
                          height: 80,
                          child: ListView.builder(

                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: imageController.imageFiles.length,
                              itemBuilder: (context,index){
                                print( imageController.imageFiles);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap:(){
                                            imageController.imageFiles.removeAt(index);
                                            setState(() {

                                            });
                                          },
                                          child: const Icon(Icons.cancel,size: 10,)),
                                      Container(height: 50, width:50,child: Image.file( imageController.imageFiles[index]),),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  // Text('Attach videos',style: GoogleFonts.lora()),
                  // const Gap(5),
                  // Row(
                  //   children: [
                  //     MediaPicker(onTap: (){
                  //       imageController.pickVideos();
                  //     },
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         height: 80,
                  //         child: ListView.builder(
                  //
                  //             shrinkWrap: true,
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount:  imageController.videoFiles.length,
                  //             itemBuilder: (context,index){
                  //               return Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Column(
                  //                   children: [
                  //                     GestureDetector(
                  //                         onTap:(){
                  //                           imageController.videoFiles.removeAt(index);
                  //                           setState(() {
                  //
                  //                           });
                  //                         },
                  //                         child: const Icon(Icons.cancel,size: 10,)),
                  //                     Container(height: 50, width:50,child: Image.file( imageController.videoFiles[index]),),
                  //                   ],
                  //                 ),
                  //               );
                  //             }),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Gap(10),
                  // Text('Attach audios',style: GoogleFonts.lora()),
                  // const Gap(5),
                  // Row(
                  //   children: [
                  //     MediaPicker(onTap: (){
                  //       imageController.pickAudios();
                  //     },),
                  //     Expanded(
                  //       child: Container(
                  //         height: 80,
                  //         child: ListView.builder(
                  //
                  //             shrinkWrap: true,
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount:  imageController.audioFiles.length,
                  //             itemBuilder: (context,index){
                  //               return Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Column(
                  //                   children: [
                  //                     GestureDetector(
                  //                         onTap:(){
                  //                           imageController.audioFiles.removeAt(index);
                  //                           setState(() {
                  //
                  //                           });
                  //                         },
                  //                         child: const Icon(Icons.cancel,size: 10,)),
                  //                     Container(height: 50, width:50,child: Image.file( imageController.audioFiles[index]),),
                  //                   ],
                  //                 ),
                  //               );
                  //             }),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Text('create post anonymously', style: GoogleFonts.lora(),),const Spacer(),
                  //     Switch(value: postController.isAnonymous, onChanged: (value){
                  //       postController.changePostVisibility(value);
                  //     },activeColor: AppTheme.primary,),
                  //   ],
                  // ),
                  // Visibility(
                  //   visible: !postController.isAnonymous,
                  //   child: Column(
                  //     children: [
                  //       TextFieldWidget(hintText: 'email',textController: postController.emailController,),
                  //       Gap(10),
                  //       TextFieldWidget(hintText: 'regNo',textController: postController.regNoController,),
                  //       Gap(10),
                  //       TextFieldWidget(hintText: 'name',textController: postController.nameController,),
                  //       Gap(10),
                  //       TextFieldWidget(hintText: 'current level',textController: postController.currentLevelController,),
                  //     ],
                  //   ),
                  // ),
                  const Gap(30),
                  ElevatedButton(onPressed: ()async{

               await     postController.createPost(
                        imageController);
                  },
                    style: ElevatedButton.styleFrom(primary:  AppTheme.primary,
                      fixedSize: const Size(double.infinity,50),
                      minimumSize:  const Size(double.infinity,50),
                      // minWidth: double.infinity,
                    ),
                    child: Text('Submit',style: GoogleFonts.lora(color: Colors.white),), ),

                  const Gap(20),
                ],),
            ),
          )
      ),
    );
  }
}

