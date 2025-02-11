import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_page.dart';
import 'pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/etam_kawa',
        builder: (context, state) => const EtamKawaPage(),
      ),
      GoRoute(
        path: '/bps',
        builder: (context, state) => const BPSPage(),
      ),
      GoRoute(
        path: '/hrgs',
        builder: (context, state) => const HRGSPage(),
      ),
      GoRoute(
        path: '/pic_bps',
        builder: (context, state) => const PicBPSPage(),
      ),
      GoRoute(
        path: '/pscm',
        builder: (context, state) => const PSCMPage(),
      ),
      GoRoute(
        path: '/am_service',
        builder: (context, state) => const AMPage(),
      ),
      GoRoute(
        path: '/cuti',
        builder: (context, state) => const CutiPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
