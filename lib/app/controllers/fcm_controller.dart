import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:petshop/app/modules/grooming/views/grooming_view.dart';

class FCMController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? adminFCMToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Save FCM token to Firestore
    if (token != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Users').doc(uid);
      userRef.update({'fcmToken': token});
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    // Handle the incoming message when the app is in the foreground
    print('Received message: ${message.notification?.body}');

    // Display a notification using flutter_local_notifications
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidInitializeSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings =
        InitializationSettings(android: androidInitializeSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: 'GroomingView()');

    // Add your custom logic to handle the message
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle the incoming message when the app is in the background
    print('Received background message: ${message.notification?.body}');
    // Add your custom logic to handle the message
  }

  Future<String?> getAdminToken() async {
    if (adminFCMToken == null) {
      String adminUid =
          "VwEGNfGQXlSDxXtVwkRPtsa2JeA3"; // Replace with your admin UID
      DocumentSnapshot<Map<String, dynamic>> adminSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(adminUid)
              .get();
      adminFCMToken = adminSnapshot.data()?['fcmToken'];
    }
    return adminFCMToken;
  }
}
