import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GroomingAdminController extends GetxController {
  //TODO: Implement GroomingAdminController
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? start;
  DateTime end = DateTime.now();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataOrder() {
    var order =
        firestore.collection("Order").orderBy('todayDate', descending: true);
    return order.snapshots();
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
