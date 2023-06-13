import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  void addBarang(String namabarang, String hargabarang) async {
    CollectionReference barang = firestore.collection('Barang');
    String uriImage = '';

    File file = File(image!.path);
    String ext = image!.name.split(".").last;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');
    Reference referenceImageUpload = referenceDirImage.child(uniqueFileName);

    referenceImageUpload.putFile(file);

    try {
      await referenceImageUpload.putFile(file);
      uriImage = await referenceImageUpload.getDownloadURL();
      await barang.add({
        "nama_barang": namabarang,
        "harga_barang": hargabarang,
        "foto_barang": uriImage,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil Memasukkan Data",
        onConfirm: () {
          namabarangC.clear();

          hargabarangC.clear();
          Get.back();
        },
        textConfirm: "Okay",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Error",
        middleText: "Tidak Berhasil Memasukkan Data",
      );
    }
  }

  void pickImage() async {
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (image != null) {
      print(image!.name);
      print(image!.name.split(".").last);
      print(image!.path);
    } else {
      print(image);
    }
    update();
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
