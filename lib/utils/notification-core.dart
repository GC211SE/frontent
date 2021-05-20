import 'package:gcrs/utils/noti.dart';

class FirebaseCloudMessaging implements FirebaseNotification {
  @override
  Future<bool> init() async => false;

  @override
  Future<void> show() async {
    print("ERROR");
    return;
  }
}
