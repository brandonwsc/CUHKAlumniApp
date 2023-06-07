import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/forum_new_comment_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/service/notificationService.dart';
import 'firebase_options.dart';
import 'pages/all_pages.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmToken: $fcmToken');
  uploadFCMToken();
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    print("listen");
    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    print("error");
    // Error getting token.
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const HomePage(title: 'CUHK Alumni'));
            break;
          case '/announcement':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const AnnouncementPage(title: 'Announcement'));
            break;
          case '/forum':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const ForumPage(title: 'CUHK Forum'));
            break;
          case '/notification':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const NotificationsPage(title: 'Notification'));
            break;
          case '/profile':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const ProfilePage(title: 'Profile'));
            break;
          case '/login':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Login(title: 'Login'));
            break;
          case '/forumNewPost':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ForumNewPostPage());
            break;
          case '/register':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Register(title: 'Register'));
            break;
          case '/auth':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Auth(title: 'Verify'));
            break;
          case '/success':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Success(title: 'Verify'));
            break;
          case '/setting':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                const SettingPage());
            break;
          case '/edit':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                const EditProfile(title: 'Edit Profile'));
            break;
        }
        return null;
      },
    );
  }
}
