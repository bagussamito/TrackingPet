import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../dashboard/controllers/dashboard_controller.dart';

class DetailGroomingController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DashboardController dashboardController = Get.find();

  void fetchSteps(String id) async {
    try {
      // Ambil data layanan grooming admin berdasarkan ID
      var snapshot = await firestore.collection('Tracking').doc(id).get();
      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data()!;
        steps.clear();
        steps.addAll([
          data['step0'] ?? '',
          data['step1'] ?? '',
          data['step2'] ?? '',
          data['step3'] ?? '',
        ]);
      }
    } catch (error) {
      print('Error fetching steps: $error');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDataGroomingUser(
      String id) {
    var user = firestore.collection("Tracking").doc(id);
    return user.snapshots();
  }

  CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection('Notifications');

  Future<void> sendNotificationToUser(
      String uid, String title, String message) async {
    String serverKey =
        'AAAA6JsekTQ:APA91bGryI4OESo9Aw6h_MnNep1wp9U4qed2MEA_suEuGeiBUwTYcgKw4RKh93upT1XlX9eUPX0KYoGy6Nurdz1Pok6Sv1nOZG8FNQhrwU_wsHEGYw3goqa_JgenBOR9BWfc0B1iil8b';

    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await firestore.collection('Users').doc(uid).get();

    String fcmToken = userSnapshot.data()?['fcmToken'] ?? '';
    List<String> tokens = [fcmToken];

    for (String token in tokens) {
      await notificationsRef.add({
        'title': title,
        'message': message,
        'read': false,
        'timestamp': DateTime.now(),
        'token': token,
        'uid': uid,
      });

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': message,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
            'registration_ids': [token],
          },
        ),
      );
    }
  }

  void goToNextStep() {
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  RxInt currentStep = 0.obs;
  RxList<String> steps = List<String>.filled(4, '', growable: false).obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
