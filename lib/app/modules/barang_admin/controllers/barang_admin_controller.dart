import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:rxdart/rxdart.dart';

class BarangAdminController extends GetxController {
  //TODO: Implement DashboardHRController

  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  final namabarangC = TextEditingController();
  final namabarangKey = GlobalKey<FormState>().obs;
  final hargabarangC = TextEditingController();
  final hargabarangKey = GlobalKey<FormState>().obs;
  final stokbarangC = TextEditingController();
  final stokbarangKey = GlobalKey<FormState>().obs;
  final namabarangBaruC = TextEditingController();
  final namabarangBaruKey = GlobalKey<FormState>().obs;
  final hargabarangBaruC = TextEditingController();
  final hargabarangBaruKey = GlobalKey<FormState>().obs;
  final namabrgValidaator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  final ImagePicker picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? image;

  late Stream<QuerySnapshot<Map<String, dynamic>>> olahSearch;

  final TextEditingController searchController = TextEditingController();
  final BehaviorSubject<String> searchQuery = BehaviorSubject<String>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getBarangDoc() {
    return searchQuery
        .debounceTime(Duration(milliseconds: 300))
        .switchMap((query) {
      if (query.isEmpty) {
        return firestore.collection("Barang").snapshots();
      } else {
        String lowerCaseQuery = query.toLowerCase();
        String upperCaseQuery = query.toUpperCase();
        return firestore
            .collection("Barang")
            .where("nama_barang", isGreaterThanOrEqualTo: query)
            .where("nama_barang", isLessThanOrEqualTo: query + 'z')
            .snapshots();
      }
    });
  }

  void addBarang(
      String namabarang, String hargabarang, String stokbarang) async {
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
      DocumentReference docRef = await barang.add({
        // Menggunakan metode `add` untuk membuat document dengan ID otomatis
        "nama_barang": namabarang,
        "harga_barang": hargabarang,
        "stok_barang": stokbarang,
        "foto_barang": uriImage,
      });
      await docRef.update({"id": docRef.id});

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

  void editBarang(String id, String namabarang, String hargabarang,
      String stokbarang) async {
    CollectionReference barang = firestore.collection('Barang');
    DocumentReference docRef = barang.doc(id);
    try {
      await docRef.update({
        "nama_barang": namabarang,
        "harga_barang": hargabarang,
        "stok_barang": stokbarang,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil Mengubah Data",
        onConfirm: () {
          namabarangC.clear();
          hargabarangC.clear();
          stokbarangC.clear();
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
    searchQuery.add('');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // searchQuery.close();
    // searchController.dispose();
  }

  void increment() => count.value++;
}
