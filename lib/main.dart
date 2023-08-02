import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_care_admin/src/controller/user_controller.dart';
import 'package:student_care_admin/src/provider/all_provider.dart';
import 'package:student_care_admin/src/utils/loader.dart';
import 'package:student_care_admin/src/views/authentication/welcome.dart';
import 'package:student_care_admin/src/views/home/home.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

final botToastBuilder = BotToastInit();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: BotToastInit(),
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoadApp(),
      ),
    );
  }
}


class LoadApp extends ConsumerStatefulWidget {
  const LoadApp({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoadAppState();
}

class _LoadAppState extends ConsumerState<LoadApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(centralProvider).initializeApp();

  }
  @override
  Widget build(BuildContext context) {
    final centralController = ref.watch(centralProvider);
    if(centralController.isAppLoading) {
      return const Scaffold(
        //  backgroundColor: AppTheme.primary,
          body:Indicator2());
    }
    if(centralController.isUserPresent){
      if(userController.userModel!= null){

        return const HomePage();
      }


    }
    //c

    return const WelcomePage();

  }
}

