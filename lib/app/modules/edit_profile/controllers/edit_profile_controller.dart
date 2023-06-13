import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:image_picker/image_picker.dart';

import '../../../controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  //TODO: Implement EditProfileController
  FirebaseAuth auth = FirebaseAuth.instance;

  final namaKey = GlobalKey<FormState>().obs;
  final alamatKey = GlobalKey<FormState>().obs;
  final authC = Get.put(AuthController());

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  final alamatValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  late TextEditingController nameC = TextEditingController();

  late TextEditingController alamatC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  Future<DocumentSnapshot<Object?>> getUserDoc() async {
    String uid = auth.currentUser!.uid;
    DocumentReference user = firestore.collection("Users").doc(uid);
    return user.get();
  }

  XFile? image;

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

  void editProfil(String nama, String alamat) async {
    String uid = auth.currentUser!.uid;
    DocumentReference docUsers = firestore.collection("Users").doc(uid);

    try {
      Map<String, dynamic> data = {
        "name": nama,
        "alamat": alamat,
      };
      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        await storage.ref('$uid/profile.$ext').putFile(file);
        String urlImage =
            await storage.ref('$uid/profile.$ext').getDownloadURL();

        data.addAll({"profile": urlImage});
      }
      await docUsers.update(data);

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil Mengubah Data",
        onConfirm: () {
          nameC.clear();

          alamatC.clear();

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

  final count = 0.obs;
  @override
  void onInit() {
    nameC = TextEditingController();
    alamatC = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameC.dispose();
    alamatC.dispose();
    super.onClose();
  }
}
