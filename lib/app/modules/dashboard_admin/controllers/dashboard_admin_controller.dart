import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class DashboardAdminController extends GetxController {
  //TODO: Implement DashboardHRController

  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  final namabarangC = TextEditingController();
  final hargabarangC = TextEditingController();

  late TextEditingController nomorindukC = TextEditingController();

  final ImagePicker picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? image;

  // var isPasswordHidden = true.obs;

  Stream<QuerySnapshot<Object?>> getBarangDoc() {
    CollectionReference barang = firestore.collection("Barang");

    return barang.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderProses() {
    return firestore
        .collection("Order")
        .where('status', isEqualTo: 'Sedang Diproses Admin')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderDone() {
    return firestore
        .collection("Order")
        .where('status', isEqualTo: 'Selesai')
        .snapshots();
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
