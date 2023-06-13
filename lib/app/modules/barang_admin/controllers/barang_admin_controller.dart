import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as s;

class BarangAdminController extends GetxController {
  //TODO: Implement DashboardHRController

  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  final namabarangC = TextEditingController();
  final namabarangKey = GlobalKey<FormState>().obs;
  final hargabarangC = TextEditingController();
  final hargabarangKey = GlobalKey<FormState>().obs;
  final namabrgValidaator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

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

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');
    Reference referenceImageUpload = referenceDirImage.child(uniqueFileName);

    referenceImageUpload.putFile(file);

    try {
      await referenceImageUpload.putFile(file);
      uriImage = await referenceImageUpload.getDownloadURL();
      await barang.doc(namabarang).set({
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

  void editBarang(String namabarang, String hargabarang, String docID) async {
    DocumentReference barang = firestore.collection("Barang").doc(docID);
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
      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        await referenceImageUpload.putFile(file);
        await storage.ref('$docID/foto_barang.$ext').putFile(file);
        String urmage =
            await storage.ref('$docID/foto_barang.$ext').getDownloadURL();
      }
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

  void deleteBarang(String docId) async {
    DocumentReference docRef = firestore.collection("Barang").doc(docId);

    try {
      Get.defaultDialog(
        title: "Hapus Data",
        middleText: "Apakah anda yakin ingin Menghapus Data?",
        textConfirm: "Yes",
        textCancel: "No",
        onConfirm: () async {
          docRef.delete();
          Get.back();
          Get.defaultDialog(
            title: "Berhasil",
            middleText: "Berhasil Menghapus Data",
            textConfirm: "Okay",
            onConfirm: () {
              Get.back();
            },
          );
        },
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Error",
        middleText: "Tidak Berhasil Menghapus Data",
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
