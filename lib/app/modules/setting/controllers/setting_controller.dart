import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:petshop/app/theme/theme.dart';

class SettingController extends GetxController {
  //TODO: Implement SettingHRController

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final namahewanC = TextEditingController();
  final namahewanKey = GlobalKey<FormState>().obs;
  final jenishewanC = TextEditingController();
  final jenishewanKey = GlobalKey<FormState>().obs;
  final umurhewanC = TextEditingController();
  final umurhewanKey = GlobalKey<FormState>().obs;

  var isPasswordHidden = true.obs;

  Future<List<Map<String, dynamic>>> getHewanData() async {
    String uid = auth.currentUser!.uid;
    var hewan = firestore.collection("Users").doc(uid).collection('Hewan');
    var snapshot = await hewan.get();
    List<Map<String, dynamic>> hewanData = [];

    snapshot.docs.forEach((doc) {
      hewanData.add(doc.data());
    });

    return hewanData;
  }

  void deleteHewanData(String docId) {
    String uid = auth.currentUser!.uid;
    var order =
        firestore.collection('Users').doc(uid).collection('Hewan').doc(docId);

    order.delete().then((value) {
      Get.dialog(Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: backgroundOrange,
        child: Container(
          width: 300,
          height: 210,
          margin: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Icon(
                IconlyLight.tick_square,
                color: Red1,
                size: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Berhasil Menghapus Data',
                style: TextStyle(
                    color: Purple, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ));
      print('Data hewan berhasil dihapus');
    }).catchError((error) {
      // Terjadi kesalahan saat menghapus data
      // Tangani error sesuai kebutuhan Anda
      print('Terjadi kesalahan saat menghapus data hewan: $error');
    });
  }

  Stream<DocumentSnapshot<Object?>> getUserDoc() async* {
    String uid = auth.currentUser!.uid;
    DocumentReference user = firestore.collection("Users").doc(uid);
    yield* user.snapshots();
  }

  void addHewan(String namahewan, String jenishewan, String umurhewan) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colHewan =
        await firestore.collection("Users").doc(uid).collection('Hewan');

    try {
      await colHewan.doc(namahewan).set({
        "nama_hewan": namahewan,
        "jenis_hewan": jenishewan,
        "umur_hewan": umurhewan,
      });
      Get.dialog(Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: backgroundOrange,
        child: Container(
          width: 300,
          height: 210,
          margin: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Icon(
                IconlyLight.tick_square,
                color: Red1,
                size: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Berhasil Memasukkan Data',
                style: TextStyle(
                    color: Purple, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ));
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Error",
        middleText: "Tidak Berhasil Memasukkan Data",
      );
    }
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
