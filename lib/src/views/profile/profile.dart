import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/user_controller.dart';
import '../../theme/app_theme.dart';
import '../authentication/welcome.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool load=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [GestureDetector(
            onTap: ()async{
              setState(() {
                load=true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                load=false;
              });
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WelcomePage()), (route) => false);
              
            },
            child: Text('Sign out  ',style: GoogleFonts.poppins(fontSize:15 ,color: AppTheme.black)))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(70),
            Center(child: const CircleAvatar(radius:35,child: Icon(Icons.person),)),
            Center(child: Text('${userController.userModel!.userName}')),
            Gap(100),
            const Text('Email'),
            SizedBox(
              height: 40,
            //  width: 100,
              child: TextFormField(
                readOnly: true,
                cursorColor: AppTheme.primary,
              controller: TextEditingController(text:userController.userModel!.email ),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2))),
              ),
            ),
            Gap(30),
            const Text('Username'),

            SizedBox(
              height: 40,
              //  width: 100,
              child: TextFormField(
                cursorColor: AppTheme.primary,
                controller: TextEditingController(text:userController.userModel!.userName ),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2))),
              ),
            ),
            Gap(30),
            const Text('Reg No'),

            SizedBox(
              height: 40,
              //  width: 100,
              child: TextFormField(
                cursorColor: AppTheme.primary,
                controller: TextEditingController(text:userController.userModel!.regNo
                ),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2))),
              ),
            ),
          ],
        ),
      )
    );
  }
}
