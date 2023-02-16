import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:petshop/app/modules/login/views/login_view.dart';
import 'package:petshop/app/routes/app_pages.dart';
import 'package:petshop/app/theme/theme.dart';
// import 'package:petshop/app/widgets/custom_icon_login_icons.dart';

import '../../../controllers/auth_controller.dart';
// import '../../lupa_sandi/views/lupa_sandi_view.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({Key? key}) : super(key: key);
  final authC = Get.find<AuthController>();
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final dialog = await Get.defaultDialog<bool>(
            title: "Peringatan",
            middleText:
                "Apakah Anda yakin ingin keluar?\n(Perubahan Anda tidak akan tersimpan)",
            onConfirm: () {
              Navigator.pop(context, true);
              Get.offAllNamed(Routes.LOGIN);
            },
            onCancel: () {},
            textConfirm: "Ya",
            textCancel: "Tidak",
            buttonColor: Blue1,
            titleStyle: heading6.copyWith(fontWeight: FontWeight.w700));
        return dialog!;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: backgroundOrange,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundOrange,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.of(context).textScaleFactor;
              final bodyHeight = MediaQuery.of(context).size.height;
              -MediaQuery.of(context).padding.top;
              final bodyWidth = MediaQuery.of(context).size.width;
              return SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                  left: bodyWidth * 0.05,
                  right: bodyWidth * 0.05,
                  bottom: bodyHeight * 0.02,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: bodyHeight * 0.11,
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/icons/logo.png',
                          width: bodyWidth * 0.5,
                          height: bodyHeight * 0.05,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: bodyHeight * 0.08,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: controller.nameKey.value,
                          child: Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.085,
                            child: TextFormField(
                              style: TextStyle(color: dark),
                              controller: controller.nameC,
                              textInputAction: TextInputAction.next,
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              validator: controller.nameValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        IconlyLight.profile,
                                        color: Red1,
                                      )),
                                  hintText: 'Nama',
                                  hintStyle: heading6.copyWith(
                                      color: Grey1, fontSize: 14 * textScale),
                                  focusColor: Blue1,
                                  fillColor: light,
                                  filled: true,
                                  errorStyle: TextStyle(
                                    fontSize: 13.5 * textScale,
                                    color: light,
                                    background: Paint()
                                      ..strokeWidth = 13
                                      ..color = errorBg
                                      ..style = PaintingStyle.stroke
                                      ..strokeJoin = StrokeJoin.round,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: errorBg, width: 1.8),
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 2),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: error, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Blue1, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: bodyHeight * 0.005,
                        ),
                        Form(
                          key: controller.emailKey.value,
                          child: Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.085,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: controller.emailC,
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              validator: controller.emailValidator,
                              style: TextStyle(color: dark),
                              decoration: InputDecoration(
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        IconlyLight.message,
                                        color: Red1,
                                      )),
                                  hintText: 'Email',
                                  hintStyle: heading6.copyWith(
                                      color: Grey1, fontSize: 14 * textScale),
                                  focusColor: Blue1,
                                  fillColor: light,
                                  filled: true,
                                  errorStyle: TextStyle(
                                    fontSize: 13.5 * textScale,
                                    color: light,
                                    background: Paint()
                                      ..strokeWidth = 13
                                      ..color = errorBg
                                      ..style = PaintingStyle.stroke
                                      ..strokeJoin = StrokeJoin.round,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: errorBg, width: 1.8),
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 2),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: error, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Blue1, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: bodyHeight * 0.005,
                        ),
                        Obx(
                          () => Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.085,
                            child: TextFormField(
                              style: TextStyle(color: dark),
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: controller.passValidator,
                              obscureText: controller.isPasswordHidden.value,
                              controller: controller.passC,
                              decoration: InputDecoration(
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        IconlyLight.lock,
                                        color: Red1,
                                      )),
                                  hintText: 'Kata Sandi',
                                  hintStyle: heading6.copyWith(
                                      color: Grey1, fontSize: 14 * textScale),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(
                                      right: bodyWidth * 0.02,
                                    ),
                                    child: IconButton(
                                      color: Colors.black26,
                                      splashRadius: 1,
                                      icon: Icon(
                                          controller.isPasswordHidden.value
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash),
                                      onPressed: () {
                                        controller.isPasswordHidden.value =
                                            !controller.isPasswordHidden.value;
                                      },
                                    ),
                                  ),
                                  focusColor: Blue1,
                                  fillColor: light,
                                  filled: true,
                                  errorStyle: TextStyle(
                                    fontSize: 13.5 * textScale,
                                    color: light,
                                    background: Paint()
                                      ..strokeWidth = 13
                                      ..color = errorBg
                                      ..style = PaintingStyle.stroke
                                      ..strokeJoin = StrokeJoin.round,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: errorBg, width: 1.8),
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 2),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: error, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Blue1, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: bodyHeight * 0.005,
                        ),
                        Obx(
                          () => Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.085,
                            child: TextFormField(
                              style: TextStyle(color: dark),
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: controller.passValidator,
                              obscureText: controller.isPasswordHidden.value,
                              controller: controller.repeatpassC,
                              decoration: InputDecoration(
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        IconlyLight.lock,
                                        color: Red1,
                                      )),
                                  hintText: 'Ulangi Kata Sandi',
                                  hintStyle: heading6.copyWith(
                                      color: Grey1, fontSize: 14 * textScale),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(
                                      right: bodyWidth * 0.02,
                                    ),
                                    child: IconButton(
                                      color: Colors.black26,
                                      splashRadius: 1,
                                      icon: FaIcon(
                                          controller.isPasswordHidden.value
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash),
                                      onPressed: () {
                                        controller.isPasswordHidden.value =
                                            !controller.isPasswordHidden.value;
                                      },
                                    ),
                                  ),
                                  focusColor: Blue1,
                                  fillColor: light,
                                  filled: true,
                                  errorStyle: TextStyle(
                                    fontSize: 13.5 * textScale,
                                    color: light,
                                    background: Paint()
                                      ..strokeWidth = 13
                                      ..color = errorBg
                                      ..style = PaintingStyle.stroke
                                      ..strokeJoin = StrokeJoin.round,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: errorBg, width: 1.8),
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 2),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: error, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Blue1, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: bodyHeight * 0.05,
                    ),
                    Container(
                      width: bodyWidth * 0.5,
                      height: bodyHeight * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: Red1,
                      ),
                      child: TextButton(
                        child: Text(
                          'Daftar',
                          textScaleFactor: 1.3,
                          style: headingBtn.copyWith(color: Yellow1),
                        ),
                        onPressed: () => authC.register(
                          controller.nameC.text,
                          controller.emailC.text,
                          controller.passC.text,
                          controller.roleC.value,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: bodyHeight * 0.155,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          textScaleFactor: 0.8,
                          style: regular12pt.copyWith(color: light),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(LoginView()),
                          child: Text(
                            'Masuk',
                            textScaleFactor: 0.8,
                            style: bold12pt.copyWith(
                              color: light,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom *
                                0.425))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
