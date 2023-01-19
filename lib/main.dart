// ignore_for_file: avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());

  showToast(msg: 'on background message', state: ToastStates.SUCCESS);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  BlocOverrides.runZoned(
        () async {

          var token = await FirebaseMessaging.instance.getToken();
          print(token);

          FirebaseMessaging.onMessage.listen((event) {
            print('on message');
            print(event.data.toString());

            showToast(msg: 'on message', state: ToastStates.SUCCESS);
          });


          FirebaseMessaging.onMessageOpenedApp.listen((event) {
            print('on message opened app');
            print(event.data.toString());

            showToast(msg: 'on message opened app', state: ToastStates.SUCCESS);
          });

          FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


          DioHelper.init();
          await CacheHelper.init();

          late Widget widget;

          uId = CacheHelper.getData(key: 'uId');

          if(uId != null) {
            widget = const HomeLayout();
          } else {
            widget = LoginScreen();
          }

          runApp(MyApp(
            startWidget: widget,
          ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startWidget}) : super(key: key);
  final Widget startWidget;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialCubit()..getUserData()..getPosts(),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}