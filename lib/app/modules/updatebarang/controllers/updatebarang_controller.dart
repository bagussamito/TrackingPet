import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdatebarangController extends GetxController {
  final namabarangKey = GlobalKey<FormState>().obs;
  final hargabarangKey = GlobalKey<FormState>().obs;
  late TextEditingController namabarangC;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  late TextEditingController hargabarangC;
  final ImagePicker picker = ImagePicker();

  XFile? image;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getData(String nama_barang) async {
    DocumentReference docRef = firestore.collection("Barang").doc(nama_barang);
    return docRef.get();
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

  void editBarang(
      String namabarang, String hargabarang, String nama_barang) async {
    DocumentReference barang = firestore.collection("Barang").doc(nama_barang);
    String uriImage = '';
    File file = File(image!.path);

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');
    Reference referenceImageUpload = referenceDirImage.child(uniqueFileName);

    referenceImageUpload.putFile(file);

    try {
      uriImage = await referenceImageUpload.getDownloadURL();
      Map<String, dynamic> data = {
        "nama_barang": namabarang,
        "harga_barang": hargabarang,
        "foto_barang": uriImage
      };

      await barang.update(data);

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil Mengubah Data",
        onConfirm: () {
          namabarangC.clear();

          hargabarangC.clear();

          Get.back();
          Get.back();
        },
        textConfirm: "Okay",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Error",
        middleText: "Tidak Berhasil Mengubah Data",
      );
    }
  }

  @override
  void onInit() {
    namabarangC = TextEditingController();

    hargabarangC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    namabarangC.dispose();

    hargabarangC.dispose();
    super.onClose();
  }
}
