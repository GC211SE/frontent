import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:html' as html;
import 'noti.dart';

// Flutter web FCM References
//  - https://github.com/doyle-flutter/flutter2fcm/tree/flutter2
//  - https://scorpio-mercury.tistory.com/14

class FirebaseCloudMessaging implements FirebaseNotification {
  static Future<void> backInit(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message');
    html.window.alert('back Title');
    return;
  }

  @override
  Future<bool> init() async => await Future(() async {
        await Firebase.initializeApp();
        RemoteMessage? r = await FirebaseMessaging.instance.getInitialMessage();
        print("INIT r : ${r ?? 'r'}");
        String? token = await FirebaseMessaging.instance.getToken();
        print("token : ${token ?? 'token NULL!'}");
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        FirebaseMessaging?.onBackgroundMessage(FirebaseCloudMessaging.backInit);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification? notification = message.notification;
          html.window.alert(
              '${notification?.title ?? "Title"}\n${notification?.body ?? "Body"}');
        });
        return true;
      });

  @override
  Future<void> show() async => html.window.alert('wp Title');
}
