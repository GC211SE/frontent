import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'noti.dart';

class FirebaseCloudMessaging implements FirebaseNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Call localNoti constructor

  AndroidNotificationDetails android = AndroidNotificationDetails(
      'id', 'notiTitle', 'notiDesc',
      importance: Importance.max, priority: Priority.max); //Initate Android
  IOSNotificationDetails ios = IOSNotificationDetails(); // Initate IOS

  NotificationDetails? detail;

  static Future<void> backInit(RemoteMessage message) async {
    await Firebase.initializeApp(); // Initate flutterfire
    print('Handling a background message ${message.messageId}');
    return;
  }

  @override
  Future<bool> init() async => await Future(() async {
        PermissionStatus status =
            await Permission.notification.request(); // Request notification
        while (status.isDenied) {
          status = await Permission.notification.request();
          await openAppSettings();
        } // If permission was rejected
        if (Platform.isIOS) {}
        AndroidInitializationSettings initSettingsAndroid =
            AndroidInitializationSettings('app_icon'); // Initate android
        IOSInitializationSettings initSettingsIOS = IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        ); // Initate IOS
        InitializationSettings initSettings = InitializationSettings(
          android: initSettingsAndroid,
          iOS: initSettingsIOS,
        ); // Initiate OS
        flutterLocalNotificationsPlugin.initialize(initSettings);
        detail = NotificationDetails(android: android, iOS: ios);
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(AndroidNotificationChannel(
              'high_importance_channel', // id
              'High Importance Notifications', // title
              'This channel is used for important notifications.', // description
              importance: Importance.high,
            ));
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return;
      }).then((_) async {
        await Firebase.initializeApp();

        FirebaseMessaging?.onBackgroundMessage(FirebaseCloudMessaging.backInit);
        RemoteMessage? r = await FirebaseMessaging.instance.getInitialMessage();

        print("INIT r : $r");
        String? token = await FirebaseMessaging.instance.getToken();
        print("token : ${token ?? 'token NULL!'}");
        if (Platform.isIOS) {
          await FirebaseMessaging.instance
              .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
        }

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;
          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(notification.hashCode,
                notification.title, notification.body, detail);
          }
        });
        FirebaseMessaging.onMessageOpenedApp
            .listen((RemoteMessage message) => print('ON_APP :$message'));
        return true;
      });

  @override
  Future<void> show() async => this
      .flutterLocalNotificationsPlugin
      .show(1, "Alarm title", "Alarm contents", this.detail);
}
