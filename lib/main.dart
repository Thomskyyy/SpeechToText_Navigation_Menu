import 'package:flutter/material.dart';
import 'package:speechmenu/HomePage.dart';
import 'package:speechmenu/AM.dart';
import 'package:speechmenu/BPS.dart';
import 'package:speechmenu/Cuti.dart';
import 'package:speechmenu/EtamKawa.dart';
import 'package:speechmenu/HRGS.dart';
import 'package:speechmenu/PSCM.dart';
import 'package:speechmenu/PicBPS.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes:[
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/etam_kawa', builder: (context, state) => const EtamKawaPage()),
      GoRoute(path: '/bps', builder: (context, state) => const BPSPage()),
      GoRoute(path: '/hrgs', builder: (context, state) => const HRGSPage()),
      GoRoute(path: '/pic_bps', builder: (context, state) => const PicBPSPage()),
      GoRoute(path: '/pscm', builder: (context, state) => const PSCMPage()),
      GoRoute(path: '/am_service', builder: (context, state) => const AMPage()),
      GoRoute(path: '/cuti', builder: (context, state) => const CutiPage()),
    ]  
  );


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

