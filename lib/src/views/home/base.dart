import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../profile/profile.dart';
import 'home.dart';

class Base extends ConsumerStatefulWidget {
  const Base({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BaseState();
}

class _BaseState extends ConsumerState<Base> {
  List<Widget> widgetList =[

    HomePage(),
    ProfileScreen(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val){
          setState(() {
            currentIndex=val;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,color: currentIndex==0?AppTheme.primary:null,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: currentIndex==1?AppTheme.primary:null),label: '')
        ],
        currentIndex:currentIndex,

      ),
    );
  }
}
