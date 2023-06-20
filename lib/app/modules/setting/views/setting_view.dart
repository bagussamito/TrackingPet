import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:petshop/app/routes/app_pages.dart';
import 'package:petshop/app/utils/loading.dart';

import '../../../controllers/auth_controller.dart';
import '../../../theme/theme.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  SettingView({Key? key}) : super(key: key);
  final SettingController controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: light,
      body: StreamBuilder<DocumentSnapshot<Object?>>(
          stream: controller.getUserDoc(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return LoadingView();
            }
            if (snap.hasData) {
              var nama = snap.data!.get("name");
              var alamat = snap.data!.get("alamat");
              var email = snap.data!.get("email");
              var pass = snap.data!.get("password");
              var defaultImage =
                  "https://ui-avatars.com/api/?name=${nama}&background=fff38a&color=5175c0&font-size=0.33";
              return LayoutBuilder(
                builder: (context, constraints) {
                  final mediaQueryHeight = MediaQuery.of(context).size.height;
                  final bodyHeight =
                      mediaQueryHeight - MediaQuery.of(context).padding.top;
                  final bodyWidth = MediaQuery.of(context).size.width;
                  final authC = Get.find<AuthController>();
                  return SingleChildScrollView(
                    reverse: false,
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      bottom: bodyHeight * 0.02,
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(children: [
                          SizedBox(
                            height: bodyHeight * 0.07,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: bodyHeight * 0.01,
                              ),
                              ClipOval(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  height: bodyHeight * 0.09,
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
                              SizedBox(
                                width: bodyHeight * 0.015,
                              ),
                              Container(
                                height: bodyHeight * 0.125,
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.06,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02,
                                  bottom: bodyHeight * 0.015,
                                  top: bodyHeight * 0.025,
                                ),
                                decoration: BoxDecoration(
                                    color: Grey1,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          "$nama",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 1.2,
                                          overflow: TextOverflow.ellipsis,
                                          style: regular12pt.copyWith(
                                              color: Purple,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: bodyHeight * 0.01,
                                        ),
                                        AutoSizeText(
                                          "$alamat",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 1.2,
                                          overflow: TextOverflow.ellipsis,
                                          style: regular12pt.copyWith(
                                              color: Purple,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    ClipOval(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(
                                          onPressed: () => Get.toNamed(
                                              Routes.EDIT_PROFILE,
                                              arguments: snap.data!.data()),
                                          icon: Icon(
                                            IconlyLight.edit,
                                            color: Red1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: bodyHeight * 0.025,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Text(
                                "Pengaturan Akun",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: Purple),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () => Get.toNamed(
                                        Routes.EDIT_EMAILPASS,
                                        arguments: snap.data!.data()),
                                    icon: Icon(
                                      IconlyLight.edit,
                                      color: Red1,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: bodyHeight * 0.010,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: bodyHeight * 0.065,
                            decoration: BoxDecoration(
                                color: Grey1,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(
                                      IconlyLight.message,
                                      color: Red1,
                                    )),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.015,
                                ),
                                Text(
                                  "$email",
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Purple),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: bodyHeight * 0.025,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: bodyHeight * 0.065,
                            decoration: BoxDecoration(
                                color: Grey1,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(IconlyLight.lock, color: Red1)),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.015,
                                ),
                                Obx(
                                  () => Text(
                                    controller.isPasswordHidden == false
                                        ? "$pass"
                                        : '${'${pass.replaceAll(RegExp(r"."), "*")}'}',
                                    textAlign: TextAlign.start,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Purple),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: bodyHeight * 0.025,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Text(
                                "Tambah Data Hewan",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, color: Purple),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.dialog(
                                        Dialog(
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
                                                Text("Tambah Data Hewan",
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: 1,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Purple,
                                                    )),
                                                SizedBox(
                                                  height: bodyHeight * 0.02,
                                                ),
                                                Form(
                                                  key: controller
                                                      .namahewanKey.value,
                                                  child: TextFormField(
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        controller.namahewanC,
                                                    style:
                                                        TextStyle(color: dark),
                                                    decoration: InputDecoration(
                                                        prefixIcon: Align(
                                                            widthFactor: 1.0,
                                                            heightFactor: 1.0,
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .newspaper,
                                                              color: Red1,
                                                            )),
                                                        hintText: 'Nama Hewan',
                                                        hintStyle:
                                                            heading6.copyWith(
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
                                                                PaintingStyle
                                                                    .stroke
                                                            ..strokeJoin =
                                                                StrokeJoin
                                                                    .round,
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
                                                                    color:
                                                                        error,
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
                                                                BorderRadius.circular(12))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: bodyHeight * 0.02,
                                                ),
                                                Form(
                                                  key: controller
                                                      .jenishewanKey.value,
                                                  child: TextFormField(
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        controller.jenishewanC,
                                                    style:
                                                        TextStyle(color: dark),
                                                    decoration: InputDecoration(
                                                        prefixIcon: Align(
                                                            widthFactor: 1.0,
                                                            heightFactor: 1.0,
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .cat,
                                                              color: Red1,
                                                            )),
                                                        hintText: 'Jenis Hewan',
                                                        hintStyle:
                                                            heading6.copyWith(
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
                                                                PaintingStyle
                                                                    .stroke
                                                            ..strokeJoin =
                                                                StrokeJoin
                                                                    .round,
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
                                                                    color:
                                                                        error,
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
                                                                BorderRadius.circular(12))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: bodyHeight * 0.02,
                                                ),
                                                Form(
                                                  key: controller
                                                      .umurhewanKey.value,
                                                  child: TextFormField(
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        controller.umurhewanC,
                                                    style:
                                                        TextStyle(color: dark),
                                                    decoration: InputDecoration(
                                                        prefixIcon: Align(
                                                            widthFactor: 1.0,
                                                            heightFactor: 1.0,
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .listNumeric,
                                                              color: Red1,
                                                            )),
                                                        hintText: 'Umur Hewan',
                                                        hintStyle:
                                                            heading6.copyWith(
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
                                                                PaintingStyle
                                                                    .stroke
                                                            ..strokeJoin =
                                                                StrokeJoin
                                                                    .round,
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
                                                                    color:
                                                                        error,
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
                                                                BorderRadius.circular(12))),
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
                                                            BorderRadius
                                                                .circular(15),
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
                                                            controller.addHewan(
                                                          controller
                                                              .namahewanC.text,
                                                          controller
                                                              .jenishewanC.text,
                                                          controller
                                                              .umurhewanC.text,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: bodyWidth * 0.02,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
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
                                        ),
                                      );
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.add,
                                      color: Red1,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.2,
                            color: Colors.transparent,
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: controller.getHewanData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Purple),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List<Map<String, dynamic>> listAllDocs =
                                      snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                      bottom: bodyHeight * 0.02,
                                      top: bodyHeight * 0.01,
                                    ),
                                    itemCount: listAllDocs.length,
                                    itemBuilder: (context, index) {
                                      var hewanData = listAllDocs[index];
                                      String docId =
                                          hewanData.containsKey('nama_hewan')
                                              ? hewanData['nama_hewan']
                                              : '';

                                      return Padding(
                                        padding:
                                            EdgeInsets.all(bodyHeight * 0.006),
                                        child: Material(
                                          color: backgroundOrange,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: bodyHeight * 0.01,
                                                    horizontal:
                                                        bodyWidth * 0.03,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Nama Hewan: ${hewanData["nama_hewan"]}',
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'Jenis Hewan: ${hewanData["jenis_hewan"]}',
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'Umur Hewan: ${hewanData["umur_hewan"]}',
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (docId.isNotEmpty) {
                                                    controller
                                                        .deleteHewanData(docId);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Text('No data available');
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: bodyHeight * 0.025,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: bodyHeight * 0.07,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              color: Red1,
                            ),
                            child: TextButton(
                              onPressed: () => authC.logout(),
                              /*authC.logut(emailC.text, passC.text)*/
                              child: Text(
                                'Logout',
                                textScaleFactor: 1.3,
                                style: headingBtn.copyWith(color: Yellow1),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              );
            } else {
              return LoadingView();
            }
          }),
    );
  }
}
