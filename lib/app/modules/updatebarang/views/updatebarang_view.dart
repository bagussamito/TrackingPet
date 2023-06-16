import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../controllers/updatebarang_controller.dart';

class UpdatebarangView extends GetView<UpdatebarangController> {
  final UpdatebarangController controller = Get.put(UpdatebarangController());
  final GlobalKey<FormState> namabarangKey = GlobalKey<FormState>();

  final GlobalKey<FormState> hargabarangKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> listAllDocs =
        Get.arguments;
    var namaBarang = listAllDocs[0].data()!['nama_barang'];

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.getBarangDoc(namaBarang),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return LoadingView();
          }
          if (snap.hasData) {
            var listAllDocs = snap.data;

            controller.namabarangC.text = listAllDocs!['nama_barang'];
            controller.hargabarangC.text = listAllDocs!['harga_barang'];

            return LayoutBuilder(builder: (context, Constraints) {
              final textScale = MediaQuery.of(context).textScaleFactor;
              final bodyHeight = MediaQuery.of(context).size.height;
              -MediaQuery.of(context).padding.top;
              final bodyWidth = MediaQuery.of(context).size.width;
              return SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.only(
                  left: bodyWidth * 0.05,
                  right: bodyWidth * 0.05,
                  bottom: bodyHeight * 0.01,
                ),
                child: Column(
                  children: [
                    Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                      child: Container(
                        width: bodyWidth * 2,
                        height: bodyHeight * 0.5,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text("Edit Barang",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Purple,
                                )),
                            SizedBox(
                              height: bodyHeight * 0.02,
                            ),
                            Form(
                              key: controller.namabarangKey.value,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: controller.namabarangC,
                                style: TextStyle(color: dark),
                                decoration: InputDecoration(
                                    prefixIcon: Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: Icon(
                                          Icons.input_sharp,
                                          color: Red1,
                                        )),
                                    hintText: 'Nama Barang',
                                    hintStyle: heading6.copyWith(
                                        color: Grey1, fontSize: 14),
                                    focusColor: Blue1,
                                    fillColor: light,
                                    filled: true,
                                    errorStyle: TextStyle(
                                      fontSize: 13.5,
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
                                        borderSide: BorderSide(
                                            color: error, width: 1.8),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Blue1, width: 1.8),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                              ),
                            ),
                            SizedBox(
                              height: bodyHeight * 0.02,
                            ),
                            Form(
                              key: controller.hargabarangKey.value,
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                textInputAction: TextInputAction.next,
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: controller.hargabarangC,
                                style: TextStyle(color: dark),
                                decoration: InputDecoration(
                                    prefixIcon: Align(
                                        widthFactor: 1.0,
                                        heightFactor: 1.0,
                                        child: FaIcon(
                                          FontAwesomeIcons.moneyBill1,
                                          color: Red1,
                                        )),
                                    hintText: 'Harga Barang',
                                    hintStyle: heading6.copyWith(
                                        color: Grey1, fontSize: 14),
                                    focusColor: Blue1,
                                    fillColor: light,
                                    filled: true,
                                    errorStyle: TextStyle(
                                      fontSize: 13.5,
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
                                        borderSide: BorderSide(
                                            color: error, width: 1.8),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Blue1, width: 1.8),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                              ),
                            ),
                            SizedBox(
                              height: bodyHeight * 0.05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: backgroundOrange,
                                  ),
                                  width: bodyWidth * 0.2,
                                  height: bodyHeight * 0.05,
                                  child: TextButton(
                                    child: Text(
                                      "Simpan",
                                      style: TextStyle(color: Purple),
                                    ),
                                    onPressed: () => controller.editBarang(
                                        controller.namabarangC.text,
                                        controller.hargabarangC.text,
                                        namaBarang),
                                  ),
                                ),
                                SizedBox(
                                  width: bodyWidth * 0.02,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: backgroundOrange,
                                  ),
                                  width: bodyWidth * 0.2,
                                  height: bodyHeight * 0.05,
                                  child: TextButton(
                                      child: Text(
                                        "Batal",
                                        style: TextStyle(color: Purple),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      }),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
