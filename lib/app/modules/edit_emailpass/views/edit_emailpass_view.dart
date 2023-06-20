import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:petshop/app/modules/home/views/home_view.dart';
import 'package:petshop/app/utils/loading.dart';

import '../../../theme/theme.dart';
import '../../setting/views/setting_view.dart';
import '../controllers/edit_emailpass_controller.dart';

class EditEmailpassView extends GetView<EditEmailpassController> {
  const EditEmailpassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;
    return FutureBuilder<DocumentSnapshot<Object?>>(
        future: controller.getUserDoc(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            var nama = controller.nameC.text = user['name'];
            controller.emailC.text = user['email'];
            var defaultImage =
                "https://ui-avatars.com/api/?name=${nama}&background=fff38a&color=5175c0&font-size=0.33";

            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: light,
              body: LayoutBuilder(
                builder: (context, constraint) {
                  final textScale = MediaQuery.of(context).textScaleFactor;

                  double bodyHeight = constraint.maxHeight;
                  double bodyWidth = constraint.maxWidth;
                  return SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.only(
                      left: bodyWidth * 0.05,
                      right: bodyWidth * 0.05,
                      bottom: bodyHeight * 0.01,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: bodyHeight * 0.06,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Get.back(),
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: dark,
                                ))
                          ],
                        ),
                        SizedBox(height: bodyHeight * 0.04),
                        Column(
                          children: [
                            Center(
                              child: ClipOval(
                                child: Container(
                                  width: bodyWidth * 0.46,
                                  height: bodyHeight * 0.22,
                                  color: Colors.grey.shade200,
                                  child: Image.network(
                                    snap.data!.get("profile") != null
                                        ? snap.data!.get("profile") != ""
                                            ? snap.data!.get("profile")
                                            : defaultImage
                                        : defaultImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: bodyHeight * 0.08,
                            ),
                            Form(
                              key: controller.emailKey.value,
                              child: Container(
                                width: bodyWidth * 1,
                                height: bodyHeight * 0.085,
                                child: TextFormField(
                                  enabled: false,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: controller.emailC,
                                  style: TextStyle(color: Purple),
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Align(
                                          widthFactor: 1.0,
                                          heightFactor: 1.0,
                                          child: Icon(
                                            IconlyLight.message,
                                            color: Red1,
                                          )),
                                      focusColor: Grey1,
                                      fillColor: Grey1,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gapPadding: 2),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: error, width: 1.8),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Yellow1, width: 1.8),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      hintText: 'Email',
                                      hintStyle: heading6.copyWith(
                                          color: Grey1,
                                          fontSize: 14 * textScale),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: bodyHeight * 0.015,
                            ),
                            Form(
                              key: controller.currentpassKey.value,
                              child: Obx(
                                () => Container(
                                  width: bodyWidth * 1,
                                  height: bodyHeight * 0.085,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: TextStyle(color: Purple),
                                    onTap: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }

                                      // controller.iconPass.value =
                                      //     !controller.iconPass.value;
                                    },
                                    validator: controller.passValidator,
                                    obscureText:
                                        controller.isPasswordHidden.value,
                                    controller: controller.currentpassC,
                                    decoration: InputDecoration(
                                        prefixIcon: Align(
                                            widthFactor: 1.0,
                                            heightFactor: 1.0,
                                            child: Icon(
                                              IconlyLight.lock,
                                              color: Red1,
                                            )),
                                        hintText: 'Kata Sandi Saat Ini',
                                        hintStyle: heading6.copyWith(
                                            color: Grey2,
                                            fontSize: 14 * textScale),
                                        fillColor: Grey1,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            gapPadding: 2),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: error, width: 1.8),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Yellow1, width: 1.8),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          child: IconButton(
                                            color: Colors.black26,
                                            splashRadius: 1,
                                            icon: Icon(controller
                                                    .isPasswordHidden.value
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded),
                                            onPressed: () {
                                              controller
                                                      .isPasswordHidden.value =
                                                  !controller
                                                      .isPasswordHidden.value;
                                            },
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: bodyHeight * 0.015,
                            ),
                            Form(
                              key: controller.newpassKey.value,
                              child: Obx(
                                () => Container(
                                  width: bodyWidth * 1,
                                  height: bodyHeight * 0.085,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: TextStyle(color: Purple),
                                    onTap: () {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }

                                      // controller.iconPass.value =
                                      //     !controller.iconPass.value;
                                    },
                                    validator: controller.passValidator,
                                    obscureText:
                                        controller.isPasswordHidden.value,
                                    controller: controller.newpassC,
                                    decoration: InputDecoration(
                                        prefixIcon: Align(
                                            widthFactor: 1.0,
                                            heightFactor: 1.0,
                                            child: Icon(
                                              IconlyLight.lock,
                                              color: Red1,
                                            )),
                                        hintText: 'Kata Sandi Baru',
                                        hintStyle: heading6.copyWith(
                                            color: Grey2,
                                            fontSize: 14 * textScale),
                                        fillColor: Grey1,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            gapPadding: 2),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: error, width: 1.8),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Yellow1, width: 1.8),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          child: IconButton(
                                            color: Colors.black26,
                                            splashRadius: 1,
                                            icon: Icon(controller
                                                    .isPasswordHidden.value
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded),
                                            onPressed: () {
                                              controller
                                                      .isPasswordHidden.value =
                                                  !controller
                                                      .isPasswordHidden.value;
                                            },
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: bodyHeight * 0.06,
                            ),
                            Container(
                              width: bodyWidth * 1,
                              height: bodyHeight * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: Red1,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  controller
                                      .updatePass(controller.newpassC.text);
                                },
                                child: Text(
                                  'Kirim',
                                  textScaleFactor: 1.3,
                                  style: headingBtn.copyWith(color: Yellow1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom *
                                        1))
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return LoadingView();
          }
        });
  }
}
