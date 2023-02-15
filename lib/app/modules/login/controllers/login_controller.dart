import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final emailC = TextEditingController();
  final passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  final emailKey = GlobalKey<FormState>().obs;
  final passKey = GlobalKey<FormState>().obs;

  final emailValidator = MultiValidator([
    EmailValidator(errorText: "Email tidak valid"),
    RequiredValidator(errorText: "Kolom harus diisi")
  ]);
  final passValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
    MinLengthValidator(6, errorText: "Kata sandi kurang dari 6 karakter"),
  ]);

  final isKeyboard = false.obs;

  final iconEmail = false.obs;
  final iconPass = false.obs;

  final count = 0.obs;
  var isPasswordHidden = true.obs;
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
