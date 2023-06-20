import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class EditEmailpassController extends GetxController {
  //TODO: Implement EditEmailpassHRController

  var isPasswordHidden = true.obs;
  var isPasswordHidden1 = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final authC = Get.put(AuthController());

  final emailKey = GlobalKey<FormState>().obs;
  final currentpassKey = GlobalKey<FormState>().obs;
  final newpassKey = GlobalKey<FormState>().obs;

  late TextEditingController nameC = TextEditingController();
  late TextEditingController emailC = TextEditingController();
  late TextEditingController currentpassC = TextEditingController();
  late TextEditingController newpassC = TextEditingController();

  Future<DocumentSnapshot<Object?>> getUserDoc() async {
    String uid = auth.currentUser!.uid;
    DocumentReference user = firestore.collection("Users").doc(uid);
    return user.get();
  }

  // emailUser.toString() != emailC.text
  final passValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
    MinLengthValidator(6, errorText: "Kata sandi kurang dari 6 karakter"),
  ]);

  final isKeyboard = false.obs;

  final iconEmail = false.obs;
  final iconPass = false.obs;

  void syncUserPassword(
    String password,
  ) async {
    String uid = auth.currentUser!.uid;
    DocumentReference docUsers = firestore.collection("Users").doc(uid);
    try {
      await docUsers.update({
        "password": password,
      });
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak Berhasil Memasukkan Data",
      );
    }
  }

  //update password
  void updatePass(String password) async {
    String emailUser = auth.currentUser!.email!;
    if (currentpassC.text.isNotEmpty && newpassC.text.isNotEmpty) {
      if (newpassC.text != currentpassC.text) {
        try {
          UserCredential myUser = await auth.signInWithEmailAndPassword(
              email: emailUser, password: currentpassC.text);
          // await auth.currentUser!.updateEmail(emailC.text);
          await auth.currentUser!.updatePassword(newpassC.text);
          syncUserPassword(password);
          await Get.defaultDialog(
            title: "Berhasil",
            middleText: "Berhasil Mengubah Data",
            onConfirm: () {
              auth.signOut();
              Get.back();
              Get.back();
            },
            textConfirm: "Oke",
          );

          UserCredential myUserNew = await auth.signInWithEmailAndPassword(
              email: emailUser, password: newpassC.text);
          Get.back();
          Get.back();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.defaultDialog(
              title: 'Terjadi Kesalahan',
              middleText: 'Kata Sandi yang dimasukkan salah.',
            );
          } else {
            Get.defaultDialog(
              title: 'Terjadi Kesalahan',
              middleText: '${e.code.toLowerCase()}',
            );
          }
        } catch (e) {
          Get.defaultDialog(
            title: "Terjadi Kesalahan",
            middleText: "Tidak dapat mengubah password.",
          );
        }
      } else {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Kata Sandi tidak boleh sama.",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan!",
        middleText: "Kolom harus diisi.",
      );
    }
  }

  void syncUserEmail(
    String email,
  ) async {
    String uid = auth.currentUser!.uid;
    DocumentReference docUsers = firestore.collection("Users").doc(uid);
    try {
      await docUsers.update({
        "email": email,
      });
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak Berhasil Memasukkan Data",
      );
    }
  }

  void updateEmail(String email) async {
    String emailUser = auth.currentUser!.email!;

    if (emailC.text.isNotEmpty) {
      if (emailUser.toString() != emailC.text) {
        try {
          // UserCredential myUser = await auth.signInWithEmailAndPassword(
          //     email: emailUser, password: );
          await auth.currentUser!.updateEmail(emailC.text);

          syncUserEmail(email);
          await Get.defaultDialog(
            title: "Berhasil",
            middleText: "Berhasil Mengubah Data",
            onConfirm: () {
              auth.signOut();
              Get.back();
              Get.back();
            },
            textConfirm: "Oke",
          );

          UserCredential myUserNew = await auth.signInWithEmailAndPassword(
              email: emailUser, password: newpassC.text);
          Get.back();
          Get.back();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.defaultDialog(
              title: 'Terjadi Kesalahan',
              middleText: 'Kata Sandi yang dimasukkan salah.',
            );
          } else {
            Get.defaultDialog(
              title: 'Terjadi Kesalahan',
              middleText: '${e.code.toLowerCase()}',
            );
          }
        } catch (e) {
          Get.defaultDialog(
            title: "Terjadi Kesalahan",
            middleText: "Tidak dapat mengubah password.",
          );
        }
      } else {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Kata Sandi tidak boleh sama.",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan!",
        middleText: "Kolom harus diisi.",
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
