import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController

  final emailC = TextEditingController();
  final alamatC = TextEditingController();
  final passC = TextEditingController();

  final repeatpassC = TextEditingController();
  final nameC = TextEditingController();

  final nameKey = GlobalKey<FormState>().obs;
  final emailKey = GlobalKey<FormState>().obs;
  final alamatKey = GlobalKey<FormState>().obs;

  final passKey = GlobalKey<FormState>().obs;
  final repeatpassKey = GlobalKey<FormState>().obs;

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  final emailValidator = MultiValidator([
    EmailValidator(errorText: "Email tidak valid"),
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  final alamatValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  final passValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
    MinLengthValidator(6, errorText: "Kata sandi kurang dari 6 karakter"),
  ]);

  var isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
