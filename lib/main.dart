import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///to initialize flutter engine and estalbish binding to flutter framework itself,
  /// for async call to be handeld gracefully , any othe rpackages might require native code calls on native devices ,
  ///therefore, flutter engine itself mus tbe initialized...
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse r) {});
//       //you cna also do the requestnotificationpermission act for each platform specific implementation
//  await  flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .createNotificationChannel(
//             AndroidNotificationChannel('abc', 'basic not'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        buttonTheme: ButtonTheme.of(context)
            .copyWith(textTheme: ButtonTextTheme.primary),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
