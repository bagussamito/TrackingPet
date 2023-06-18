import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GroomingAdminController extends GetxController {
  //TODO: Implement GroomingAdminController
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? start;
  DateTime end = DateTime.now();
  String? userFCMToken;
  var isServiceAccepted = false.obs;

  Future<void> acceptService() async {
    // Logika untuk menerima layanan

    // Set nilai variabel isServiceAccepted menjadi true setelah menerima layanan
    isServiceAccepted.value = true;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataOrder() {
    var order =
        firestore.collection("Order").where('status', isNotEqualTo: 'Selesai');
    // .orderBy('todayDate', descending: true);
    return order.snapshots();
  }

  CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection('Notifications');

// Fungsi untuk mengirim notifikasi ke user
  Future<void> sendNotificationToUser(
      String uid, String title, String message) async {
    String serverKey =
        'AAAA6JsekTQ:APA91bGryI4OESo9Aw6h_MnNep1wp9U4qed2MEA_suEuGeiBUwTYcgKw4RKh93upT1XlX9eUPX0KYoGy6Nurdz1Pok6Sv1nOZG8FNQhrwU_wsHEGYw3goqa_JgenBOR9BWfc0B1iil8b'; // Replace with your actual server key
    String? userToken = await getUserToken(uid);

    // Kirim notifikasi ke token pengguna

    // await notificationsRef.add({
    //   'title': title,
    //   'message': message,
    //   'read': false,
    //   'timestamp': DateTime.now(),
    //   'token': userToken,
    //   'uid': uid,
    // });

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
          'to': userToken,
        },
      ),
    );
  }

  Future<String?> getUserToken(String uid) async {
    if (userFCMToken == null) {
      // String adminUid =
      //     "VwEGNfGQXlSDxXtVwkRPtsa2JeA3"; // Replace with your admin UID
      DocumentSnapshot<Map<String, dynamic>> adminSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      userFCMToken = adminSnapshot.data()!['fcmToken'];
      print(userFCMToken);
    }
    return userFCMToken;
  }

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
