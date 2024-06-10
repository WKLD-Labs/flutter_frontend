import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wkldlabs_flutter_frontend/views/LoginPage/logout.dart';
import 'package:wkldlabs_flutter_frontend/widgets/nav_drawer.dart';
import 'package:wkldlabs_flutter_frontend/global/login_context.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


// Views for Routing
import 'views/Document/Document.dart';
import 'views/HomePage/home_page.dart';
import 'views/DummyPage/dummy_page.dart';
import 'views/JadwalPage/jadwal_page.dart';
import 'views/AgendaPage/agenda_page.dart';
import 'views/LoginPage/login_page.dart';
import 'views/DaftarPertemuan/pertemuan_page.dart';
import 'views/InventoryPage/invetory_page.dart';
import 'views/MemberPage/member_page.dart';
import 'views/RoomSchedule/room_schedule.dart';
import 'views/LoginPage/logout.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'dummy',
          builder: (BuildContext context, GoRouterState state) {
            return const DummyPage(title: 'Flutter Demo Dummy Page');
          },
        ),
        GoRoute(
          path: 'jadwal',
          builder: (BuildContext context, GoRouterState state) {
            return const JadwalPage(title: 'Flutter Demo Jadwal Page');
          },
        ),
        GoRoute(
          path: 'agenda',
          builder: (BuildContext context, GoRouterState state) {
            return const AgendaPage(title: 'Flutter Demo Agenda Page');
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state){
            return const LoginPage(title: 'Login Page');
          },
        ),
        GoRoute(
          path: 'pertemuan',
          builder: (BuildContext context, GoRouterState state){
            return const DaftarPertemuan(title: 'Daftar Pertemuan');
          },
        ),
        GoRoute(
          path: 'inventory',
          builder: (BuildContext context, GoRouterState state){
            return const InventoryPage(title: 'Inventory Page');
          },
        ),
        GoRoute(
          path: 'member',
          builder: (BuildContext context, GoRouterState state){
            return const MemberPage(title: 'Member Page');
          },
        ),
        GoRoute(
          path: 'roomschedule',
          builder: (BuildContext context, GoRouterState state) {
            return const RoomSchedule();
          },
        ),
        GoRoute(
          path: 'document',
          builder: (BuildContext context, GoRouterState state) {
            return DocumentPage();
          },
        ),
        GoRoute(
          path: 'logout',
          builder: (BuildContext context, GoRouterState state) {
            return const LogoutPage();
          },
        ),
      ],
      redirect: (context, state) {
        (() async {
          NavDrawer.loginListener.update(await LoginContext.getIsLogin());
        })();
        return null;
      },
    ),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'wkldLabs',
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff15a24), brightness: Brightness.light),
        useMaterial3: true,
      ),
      // darkTheme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff15a24), brightness: Brightness.dark),
      //   useMaterial3: true,
      // ),
      // themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
