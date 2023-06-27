import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:latlong2/latlong.dart';

import '../../../controllers/auth_controller.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../grooming/controllers/grooming_controller.dart';
import '../controllers/layanan_grooming_admin_controller.dart';

class LayananGroomingAdminView extends GetView<LayananGroomingAdminController> {
  const LayananGroomingAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find();
    final datas = Get.arguments;
    var id = datas['id'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: light,
      body: GetBuilder<LayananGroomingAdminController>(builder: (c) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.getUserDoc(id),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return LoadingView();
            }
            if (snap.hasData) {
              var addres = datas['lokasi hewan']['address'];
              var layanan = datas['layanan'];
              var nama_hewan = datas['selected item'];
              var lat = datas['lokasi hewan']['position']['lat'].toDouble();
              var long = datas['lokasi hewan']['position']['long'].toDouble();
              String uid = datas['uid'];

              return LayoutBuilder(
                builder: (context, constraints) {
                  final textScale = MediaQuery.of(context).textScaleFactor;
                  final bodyHeight = MediaQuery.of(context).size.height;
                  -MediaQuery.of(context).padding.top;
                  final bodyWidth = MediaQuery.of(context).size.width;
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: bodyWidth * 0.05,
                      right: bodyWidth * 0.05,
                      bottom: bodyHeight * 0.02,
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
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: bodyHeight * 0.4,
                          width: bodyWidth * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FlutterMap(
                            options: MapOptions(
                              center: LatLng(lat, long),
                              zoom: 17.8,
                              maxZoom: 19.2,
                              interactiveFlags: InteractiveFlag.pinchZoom,
                            ),
                            children: [
                              TileLayer(
                                tileSize: 256.0,
                                urlTemplate:
                                    'http://{s}.google.com/vt?lyrs=m&x={x}&y={y}&z={z}',
                                subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                                maxZoom: 22,
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 40.0,
                                    height: 40.0,
                                    point: LatLng(lat, long),
                                    builder: (context) => Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: bodyHeight * 0.03,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: bodyHeight * 0.015),
                          child: Material(
                            color: Yellow1,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: bodyHeight * 0.01,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: bodyWidth * 0.06,
                                      left: bodyWidth * 0.06,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Lokasi Hewan",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "$addres",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: bodyHeight * 0.01,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: bodyWidth * 0.06,
                                      left: bodyWidth * 0.06,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Nama Hewan",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: bodyWidth * 0.157,
                                        ),
                                        Text(
                                          "$nama_hewan",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: bodyHeight * 0.01,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: bodyWidth * 0.06,
                                      left: bodyWidth * 0.06,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Layanan",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: bodyWidth * 0.228,
                                        ),
                                        Text(
                                          "$layanan",
                                          textAlign: TextAlign.start,
                                          textScaleFactor: 0.9,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Obx(
                                        () => SingleChildScrollView(
                                          child: Stepper(
                                            onStepTapped: (step) => controller
                                                .currentStep.value = step,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            currentStep:
                                                controller.currentStep.value,
                                            onStepContinue: () async {
                                              if (controller
                                                      .currentStep.value ==
                                                  2) {
                                                // Jika current step adalah step 3, lakukan aksi Confirm
                                                // Misalnya, panggil fungsi confirmStep3()
                                                controller.confirmStep3(
                                                  id: id, // Ganti dengan UID yang sesuai
                                                  title: nama_hewan,
                                                );
                                                await dashboardController
                                                    .updateOrderGroomingStatus(
                                                  datas['id'],
                                                  'Selesai',
                                                );
                                                controller.statusC.value;
                                              } else {
                                                // Jika current step bukan step 3, lanjutkan ke step berikutnya
                                                controller.goToNextStep(
                                                  id: id, // Ganti dengan UID yang sesuai
                                                  title: nama_hewan,
                                                );
                                              }
                                            },
                                            onStepCancel:
                                                controller.goToPreviousStep,
                                            steps: [
                                              Step(
                                                title:
                                                    Text('Jam Grooming Hewan'),
                                                content: Column(
                                                  children: [
                                                    Text(
                                                      'Berat Hewan',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    TextFormField(
                                                      controller: controller
                                                          .kondisihwnC,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Digrooming Jam: ${controller.jamjemputController.value}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                isActive: controller
                                                        .currentStep.value >=
                                                    0,
                                                state: controller.currentStep
                                                            .value >=
                                                        0
                                                    ? StepState.complete
                                                    : StepState.disabled,
                                              ),
                                              Step(
                                                title: Text(
                                                    'Foto Hewan Sedang Di Grooming'),
                                                content: Column(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        final imagePicker =
                                                            ImagePicker();
                                                        final pickedImage =
                                                            await imagePicker
                                                                .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                        );
                                                        if (pickedImage !=
                                                            null) {
                                                          // Upload the image to Firestore
                                                          File imageFile = File(
                                                              pickedImage.path);
                                                          controller
                                                                  .step2Controller
                                                                  .text =
                                                              pickedImage.path;

                                                          // Update the preview image
                                                          controller
                                                              .previewImagestep2
                                                              .value = imageFile;
                                                        }
                                                      },
                                                      child:
                                                          Text('Ambil Gambar'),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Obx(
                                                      () => controller
                                                                  .previewImagestep2
                                                                  .value !=
                                                              null
                                                          ? Image.file(controller
                                                              .previewImagestep2
                                                              .value!)
                                                          : Container(
                                                              height: 100,
                                                              width: 100,
                                                              color:
                                                                  Colors.grey,
                                                              child: Icon(
                                                                Icons.image,
                                                                size: 50,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                                isActive: controller
                                                        .currentStep.value >=
                                                    1,
                                                state: controller.currentStep
                                                            .value >=
                                                        1
                                                    ? StepState.complete
                                                    : StepState.disabled,
                                              ),
                                              Step(
                                                title: Text(
                                                    'Hewan Selesai Digrooming'),
                                                content: Column(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        final imagePicker =
                                                            ImagePicker();
                                                        final pickedImage =
                                                            await imagePicker
                                                                .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                        );
                                                        if (pickedImage !=
                                                            null) {
                                                          // Upload the image to Firestore
                                                          File imageFile = File(
                                                              pickedImage.path);
                                                          controller
                                                                  .step4Controller
                                                                  .text =
                                                              pickedImage.path;

                                                          // Update the preview image
                                                          controller
                                                              .previewImagestep4
                                                              .value = imageFile;
                                                        }
                                                      },
                                                      child:
                                                          Text('Ambil Gambar'),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Obx(
                                                      () => controller
                                                                  .previewImagestep4
                                                                  .value !=
                                                              null
                                                          ? Image.file(controller
                                                              .previewImagestep4
                                                              .value!)
                                                          : Container(
                                                              height: 100,
                                                              width: 100,
                                                              color:
                                                                  Colors.grey,
                                                              child: Icon(
                                                                Icons.image,
                                                                size: 50,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                    ),
                                                    Obx(
                                                      () => CheckboxListTile(
                                                        title: Text("Selesai"),
                                                        value: controller
                                                                .statusC
                                                                .value ==
                                                            "Selesai",
                                                        onChanged:
                                                            (bool? value) {
                                                          if (value != null) {
                                                            controller
                                                                .setStatus(
                                                                    value);
                                                          }
                                                        },
                                                        controlAffinity:
                                                            ListTileControlAffinity
                                                                .leading,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Selesai Jam: ${controller.jamselesaiController.value}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                isActive: controller
                                                        .currentStep.value >=
                                                    2,
                                                state: controller.currentStep
                                                            .value >=
                                                        2
                                                    ? StepState.complete
                                                    : StepState.disabled,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Container(
                child: Center(
                  child: Text("No Data"),
                ),
              );
            }
          },
        );
      }),
    );
  }
}
