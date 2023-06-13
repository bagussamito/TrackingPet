// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:petshop/app/utils/loading.dart';

import '../modules/home/views/home_view.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.userChanges();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> streamDataUsers() {
    CollectionReference users = firestore.collection("Users");
    return users.snapshots();
  }

  Future<DocumentSnapshot<Object?>> getUserDoc() async {
    String uid = auth.currentUser!.uid;
    DocumentReference user = firestore.collection("Users").doc(uid);
    return user.get();
  }

  //store user data
  void syncUsers(
    String name,
    String email,
    String password,
    String alamat,
  ) async {
    String uid = auth.currentUser!.uid.toString();

    CollectionReference users = firestore.collection('Users');
    try {
      users.doc(uid).set({
        'uid': uid,
        'name': name,
        'password': password,
        'alamat': alamat,
        'email': email,
        'profile': '',
        'role': 'pelanggan',
      });
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak Berhasil Memasukkan Data",
      );
    }
  }

  Future<DocumentSnapshot<Object?>> role() async {
    String uid = auth.currentUser!.uid;
    DocumentReference users = firestore.collection('Users').doc(uid);
    return users.get();
  }

  //login
  void login(String email, String password) async {
    try {
      UserCredential myUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (myUser.user!.emailVerified) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.defaultDialog(
            title: 'Verifikasi Email',
            middleText: 'Anda perlu verifikasi email terlebih dahulu.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.defaultDialog(
          title: 'Terjadi Kesalahan',
          middleText: 'Email tidak ditemukan.',
        );
      } else if (!GetUtils.isEmail(email)) {
        Get.defaultDialog(
          title: 'Terjadi Kesalahan',
          middleText: 'Format email salah.',
        );
      } else if (password.length < 6) {
        Get.defaultDialog(
          title: 'Terjadi Kesalahan',
          middleText: 'Password minimal 6 karakter.',
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.defaultDialog(
          title: 'Terjadi Kesalahan',
          middleText: 'Password salah.',
        );
      }
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Tidak dapat masuk.',
      );
    }
  }

  //register
  void register(
      String name, String email, String password, String alamat) async {
    try {
      UserCredential myUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await myUser.user?.updateDisplayName(name);
      syncUsers(name, email, password, alamat);
      await myUser.user!.sendEmailVerification();
      Get.defaultDialog(
          title: 'Verifikasi Email',
          middleText: 'Verifikasi Email sudah terkirim. Cek email anda.',
          onConfirm: () {
            Get.back();
            Get.back();
          },
          textConfirm: 'Okay');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: avoid_print
        print('The password provided is too weak.');
        Get.defaultDialog(
          title: 'Terjadi Kesalahan',
          middleText: 'Password terlalu lemah. Password minimal 6 karakter.',
        );
      } else if (e.code == 'email-already-in-use') {
        // ignore: avoid_print
        print('The account already exists for that email.');
        Get.defaultDialog(
          title: 'Terjadi Kesalahan',
          middleText: 'Email sudah dipakai pada akun tersebut.',
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Tidak dapat mendaftarkan akun ini',
      );
    }
  }

  //logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
