import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_care_admin/src/controller/postController.dart';
import 'package:student_care_admin/src/controller/user_controller.dart';

import '../../provider/all_provider.dart';
import '../../theme/app_theme.dart';

class AllUsers extends ConsumerStatefulWidget {
  const AllUsers({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AllUsersState();
}

class _AllUsersState extends ConsumerState<AllUsers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(postProvider
    );
    ref.read(postProvider).getAllUsers();




  }
  @override
  Widget build(BuildContext context) {
    PostController postController = ref.watch(postProvider);
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_ios_rounded,color: AppTheme.black,),),
        backgroundColor: Colors.transparent
        ,elevation: 0.0,),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('${postController.userList.length}',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),
                  Center(child: Text('User(s)',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary))),
                ],
              ),

            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            itemCount: postController.userList.length,
            itemBuilder: (context,index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  color: AppTheme.white,
                  child: Row(children:[

                    const Gap(20),
                    const CircleAvatar(radius:15,child: Icon(Icons.person),),
                    const Gap(20),
                    Text('${postController.userList[index].userName
                    }',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary)),
                    const Spacer(),
                    Text('${postController.userList[index].regNo}',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.primary)),    const Gap(15),
                  ],),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
