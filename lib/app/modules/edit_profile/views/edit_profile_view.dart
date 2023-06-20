import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({Key? key}) : super(key: key);
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;
    log("$user");
    return FutureBuilder<DocumentSnapshot<Object?>>(
      future: controller.getUserDoc(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          var nama = controller.nameC.text = user['name'];
          var alamat = controller.alamatC.text = user['alamat'];

          String defaultImage =
              "https://ui-avatars.com/api/?name=${nama}&background=fff38a&color=5175c0&font-size=0.33";
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: light,
            body: LayoutBuilder(builder: (context, constraint) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: dark,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ],
                    ),
                    SizedBox(height: bodyHeight * 0.04),
                    Column(
                      children: [
                        Stack(
                          children: [
                            GetBuilder<EditProfileController>(
                              builder: (c) {
                                if (c.image != null) {
                                  return Center(
                                    child: ClipOval(
                                      child: Container(
                                        width: bodyWidth * 0.46,
                                        height: bodyHeight * 0.22,
                                        color: Colors.grey.shade200,
                                        child: Image.file(
                                          File(c.image!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: ClipOval(
                                      child: Container(
                                        width: bodyWidth * 0.46,
                                        height: bodyHeight * 0.22,
                                        color: Colors.grey.shade200,
                                        child: Image.network(
                                          user["profile"] != null
                                              ? user["profile"] != ""
                                                  ? user["profile"]
                                                  : defaultImage
                                              : defaultImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            //button untuk ganti foto profil
                            Positioned(
                              top: bodyHeight * 0.16,
                              left: bodyWidth * 0.55,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.orange,
                                  child: IconButton(
                                    onPressed: () {
                                      controller.pickImage();
                                    },
                                    icon: Icon(
                                      IconlyLight.camera,
                                      color: light,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: bodyHeight * 0.08,
                        ),
                        Form(
                          key: controller.namaKey.value,
                          child: Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.085,
                            child: TextFormField(
                              style: TextStyle(color: Purple),
                              controller: controller.nameC,
                              textInputAction: TextInputAction.next,
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
                                      color: Purple, fontSize: 14 * textScale),
                                  focusColor: Red1,
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
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 2),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: error, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Yellow1, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                        ),
                        Form(
                          key: controller.alamatKey.value,
                          child: Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.085,
                            child: TextFormField(
                              style: TextStyle(color: Purple),
                              controller: controller.alamatC,
                              textInputAction: TextInputAction.next,
                              validator: controller.alamatValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Icon(
                                        IconlyLight.location,
                                        color: Red1,
                                      )),
                                  hintText: 'Alamat',
                                  hintStyle: heading6.copyWith(
                                      color: Purple, fontSize: 14 * textScale),
                                  focusColor: Red1,
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
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 2),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: error, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Yellow1, width: 1.8),
                                      borderRadius: BorderRadius.circular(12)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(12))),
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
                            onPressed: () => controller.editProfil(
                              controller.nameC.text,
                              controller.alamatC.text,
                            ),
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
                                MediaQuery.of(context).viewInsets.bottom * 1))
                  ],
                ),
              );
            }),
          );
        } else {
          return LoadingView();
        }
      },
    );
  }
}
