import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:petshop/app/modules/updatebarang/views/updatebarang_view.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../controllers/barang_admin_controller.dart';

class BarangAdminView extends GetView<BarangAdminController> {
  BarangAdminView({Key? key}) : super(key: key);
  final BarangAdminController controller = Get.put(BarangAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<QuerySnapshot<Object?>>(
            stream: controller.getBarangDoc(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingView();
              }
              if (snap.hasData) {
                var listAllDocs = snap.data!.docs;

                return LayoutBuilder(
                  builder: (context, constraints) {
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
                          SizedBox(
                            height: bodyHeight * 0.06,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: bodyWidth * 0.75,
                                height: bodyHeight * 0.085,
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  },
                                  style: TextStyle(color: dark),
                                  decoration: InputDecoration(
                                      prefixIcon: Align(
                                          widthFactor: 1.0,
                                          heightFactor: 1.0,
                                          child: FaIcon(
                                            FontAwesomeIcons.searchengin,
                                            color: Red1,
                                          )),
                                      hintText: 'Cari Barang',
                                      hintStyle: heading6.copyWith(
                                          color: Grey1,
                                          fontSize: 14 * textScale),
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
                                              color: Blue1, width: 1.8),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                              FloatingActionButton(
                                backgroundColor: backgroundOrange,
                                child: Icon(
                                  FontAwesomeIcons.add,
                                  color: Red1,
                                ),
                                onPressed: () {
                                  Get.dialog(Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    backgroundColor:
                                        Color.fromRGBO(255, 255, 255, 1),
                                    child: Container(
                                      width: bodyWidth * 2,
                                      height: bodyHeight * 0.5,
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text("Tambah Barang",
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Purple,
                                              )),
                                          SizedBox(
                                            height: bodyHeight * 0.02,
                                          ),
                                          Stack(
                                            children: [
                                              GetBuilder<BarangAdminController>(
                                                builder: (c) {
                                                  if (c.image != null) {
                                                    return Center(
                                                      child: Container(
                                                        width: 150,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors
                                                              .grey.shade200,
                                                        ),
                                                        child: Image.file(
                                                          File(c.image!.path),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Container(
                                                        width: 150,
                                                        height: 90,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              //button untuk ganti foto profil
                                              Positioned(
                                                child: ClipOval(
                                                  child: Material(
                                                    color: backgroundOrange,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        controller.pickImage();
                                                      },
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.camera,
                                                        color: light,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: bodyHeight * 0.02,
                                          ),
                                          Form(
                                            key: controller.namabarangKey.value,
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              onTap: () {
                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);

                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller:
                                                  controller.namabarangC,
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
                                                      color: Grey1,
                                                      fontSize: 14),
                                                  focusColor: Blue1,
                                                  fillColor: light,
                                                  filled: true,
                                                  errorStyle: TextStyle(
                                                    fontSize: 13.5,
                                                    color: light,
                                                    background: Paint()
                                                      ..strokeWidth = 13
                                                      ..color = errorBg
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeJoin =
                                                          StrokeJoin.round,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: errorBg,
                                                          width: 1.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      gapPadding: 2),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: error,
                                                              width: 1.8),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Blue1,
                                                          width: 1.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: bodyHeight * 0.02,
                                          ),
                                          Form(
                                            key:
                                                controller.hargabarangKey.value,
                                            child: TextFormField(
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              onTap: () {
                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);

                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller:
                                                  controller.hargabarangC,
                                              style: TextStyle(color: dark),
                                              decoration: InputDecoration(
                                                  prefixIcon: Align(
                                                      widthFactor: 1.0,
                                                      heightFactor: 1.0,
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .moneyBill1,
                                                        color: Red1,
                                                      )),
                                                  hintText: 'Harga Barang',
                                                  hintStyle: heading6.copyWith(
                                                      color: Grey1,
                                                      fontSize: 14),
                                                  focusColor: Blue1,
                                                  fillColor: light,
                                                  filled: true,
                                                  errorStyle: TextStyle(
                                                    fontSize: 13.5,
                                                    color: light,
                                                    background: Paint()
                                                      ..strokeWidth = 13
                                                      ..color = errorBg
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeJoin =
                                                          StrokeJoin.round,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: errorBg,
                                                          width: 1.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      gapPadding: 2),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: error,
                                                              width: 1.8),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Blue1,
                                                          width: 1.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12))),
                                            ),
                                          ),
                                          SizedBox(
                                            height: bodyHeight * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: backgroundOrange,
                                                ),
                                                width: bodyWidth * 0.2,
                                                height: bodyHeight * 0.05,
                                                child: TextButton(
                                                  child: Text(
                                                    "Simpan",
                                                    style: TextStyle(
                                                        color: Purple),
                                                  ),
                                                  onPressed: () =>
                                                      controller.addBarang(
                                                    controller.namabarangC.text,
                                                    controller
                                                        .hargabarangC.text,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: bodyWidth * 0.02,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: backgroundOrange,
                                                ),
                                                width: bodyWidth * 0.2,
                                                height: bodyHeight * 0.05,
                                                child: TextButton(
                                                    child: Text(
                                                      "Batal",
                                                      style: TextStyle(
                                                          color: Purple),
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
                                  ));
                                },
                              ),
                            ],
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  bottom: bodyHeight * 0.015,
                                  top: bodyHeight * 0.01),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: listAllDocs.length,
                              // itemCount: 20,
                              itemBuilder: (context, index) {
                                var foto_barang = {
                                  (listAllDocs[index].data()
                                      as Map<String, dynamic>)["foto_barang"]
                                };
                                var defaultImage =
                                    "https://ui-avatars.com/api/?name=${foto_barang}&background=fff38a&color=5175c0&font-size=0.33";
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: bodyHeight * 0.01),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      child: SizedBox(
                                        width: bodyWidth * 1,
                                        height: bodyHeight * 0.309,
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Image border
                                              child: Container(
                                                width: bodyWidth * 0.46,
                                                height: bodyHeight * 0.22,
                                                // Image radius
                                                child: Image.network(
                                                  "${(listAllDocs[index].data() as Map<String, dynamic>)["foto_barang"]}" !=
                                                          null
                                                      ? "${(listAllDocs[index].data() as Map<String, dynamic>)["foto_barang"]}" !=
                                                              ""
                                                          ? "${(listAllDocs[index].data() as Map<String, dynamic>)["foto_barang"]}"
                                                          : defaultImage
                                                      : defaultImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${(listAllDocs[index].data() as Map<String, dynamic>)["nama_barang"]}",
                                              textAlign: TextAlign.start,
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.paw,
                                                  color: Red1,
                                                ),
                                                SizedBox(
                                                  width: bodyWidth * 0.02,
                                                ),
                                                Text(
                                                  "${(listAllDocs[index].data() as Map<String, dynamic>)["harga_barang"]}",
                                                  textAlign: TextAlign.start,
                                                  textScaleFactor: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                ClipOval(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Get.to(
                                                            () =>
                                                                (UpdatebarangView()),
                                                            arguments:
                                                                listAllDocs[
                                                                        index]
                                                                    .data());
                                                      },
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.pencil,
                                                        color: Red1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ClipOval(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: IconButton(
                                                      onPressed: () =>
                                                          controller
                                                              .deleteBarang(
                                                                  listAllDocs[
                                                                          index]
                                                                      .id),
                                                      icon: FaIcon(
                                                        FontAwesomeIcons.trash,
                                                        color: Red1,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom *
                                          0.4))
                        ],
                      ),
                    );
                  },
                );
              } else {
                return LoadingView();
              }
            }));
  }
}
