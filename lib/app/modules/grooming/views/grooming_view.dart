import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:petshop/app/controllers/auth_controller.dart';
import 'package:petshop/app/modules/home/views/home_view.dart';
import 'package:petshop/app/routes/app_pages.dart';
import 'package:petshop/app/utils/loading.dart';

import '../../../theme/theme.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../controllers/grooming_controller.dart';

class GroomingView extends GetView<GroomingController> {
  GroomingView({Key? key}) : super(key: key);

  final GroomingController controller = Get.put(GroomingController());

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: light,
      body: GetBuilder<GroomingController>(builder: (c) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingView();
              }
              if (snap.hasData) {
                Map<String, dynamic> user = snap.data!.data()!;
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
                          Container(
                            width: bodyWidth * 1,
                            height: bodyHeight * 0.31,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: bodyHeight * 0.01,
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Tambah Data Hewan",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Purple,
                                          )),
                                    ]),
                                Container(
                                  width: bodyWidth * 1,
                                  height: bodyHeight * 0.2,
                                  color: Colors.transparent,
                                  child: StreamBuilder<QuerySnapshot<Object?>>(
                                      stream: controller.getHewanDoc(),
                                      builder: (context, snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return LoadingView();
                                        }
                                        if (snap.hasData) {
                                          var listAllDocs = snap.data!.docs;
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(
                                                  bottom: bodyHeight * 0.02,
                                                  top: bodyHeight * 0.01),
                                              itemCount: listAllDocs.length,
                                              // itemCount: 20,
                                              itemBuilder: (context, index) {
                                                var hewanData =
                                                    listAllDocs[index];
                                                bool isSelected =
                                                    controller.selectedItem ==
                                                        listAllDocs[index].id;
                                                return Padding(
                                                  padding: EdgeInsets.all(
                                                    bodyHeight * 0.006,
                                                  ),
                                                  child: Obx(
                                                    () => Material(
                                                      color: controller
                                                                  .selectedItem ==
                                                              listAllDocs[index]
                                                                  .id
                                                          ? Colors.grey
                                                          : backgroundOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          print(
                                                              "Selected item: ${(listAllDocs[index].data() as Map<String, dynamic>)["nama_hewan"]} at index $index");
                                                          controller.selectItem(
                                                              listAllDocs[index]
                                                                  .id);
                                                        },
                                                        child: SizedBox(
                                                          width: bodyWidth * 1,
                                                          height: bodyHeight *
                                                              0.071,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Nama Hewan : ${hewanData["nama_hewan"]}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color:
                                                                            Purple),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Jenis Hewan : ${hewanData["jenis_hewan"]}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color:
                                                                            Purple),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Umur Hewan : ${hewanData["umur_hewan"]}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color:
                                                                            Purple),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return LoadingView();
                                        }
                                      }),
                                ),
                                SizedBox(
                                  height: bodyHeight * 0.005,
                                ),
                                Container(
                                  width: bodyWidth * 1,
                                  height: bodyHeight * 0.062,
                                  decoration: BoxDecoration(
                                      color: light,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: DropdownSearch<String>(
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    clearButtonProps: ClearButtonProps(
                                        isVisible: true, color: Purple),
                                    items: [
                                      "REGULER",
                                      "SPA",
                                      "REGULER JAMUR",
                                      'REGULER KUTU',
                                      "REGULER KUTU JAMUR",
                                      "SPA JAMUR",
                                      "SPA KUTU",
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.setLayanan(value);
                                      }
                                    },
                                    validator: (value) {
                                      controller.layananValidator;
                                    },
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                                    prefixIcon: Align(
                                                        widthFactor: 1.0,
                                                        heightFactor: 1.0,
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .shower,
                                                          color: Purple,
                                                        )),
                                                    hintText: "Pilih Layanan",
                                                    hintStyle:
                                                        heading6.copyWith(
                                                            color: Grey1,
                                                            fontSize:
                                                                14 * textScale),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none))),
                                    popupProps: PopupProps.menu(
                                      constraints: BoxConstraints(
                                          maxHeight: bodyHeight * 0.2),
                                      scrollbarProps: ScrollbarProps(
                                          trackVisibility: true,
                                          trackColor: dark),
                                      fit: FlexFit.loose,
                                      menuProps: MenuProps(
                                        borderRadius: BorderRadius.circular(12),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                      containerBuilder: (ctx, popupWidget) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: light,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset:
                                                              Offset(0, 0.5),
                                                          blurRadius: 1,
                                                          color: dark
                                                              .withOpacity(0.5))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: popupWidget,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: bodyHeight * 0.4,
                            width: bodyWidth * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FlutterMap(
                              options: MapOptions(
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
                                CurrentLocationLayer(
                                    followOnLocationUpdate:
                                        FollowOnLocationUpdate.always,
                                    positionStream:
                                        LocationMarkerDataStreamFactory()
                                            .fromGeolocatorPositionStream(
                                      stream: controller.streamGetPosition(),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: bodyHeight * 0.04,
                          ),
                          Container(
                            height: bodyHeight * 0.28,
                            width: bodyWidth * 1,
                            padding: EdgeInsets.only(
                                left: bodyWidth * 0.06,
                                right: bodyWidth * 0.06,
                                top: bodyHeight * 0.03),
                            decoration: BoxDecoration(
                                color: Grey1,
                                borderRadius: BorderRadius.circular(22)),
                            child: StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: controller.streamLocationUser(),
                                builder: (context, snapToday) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingView();
                                  }
                                  Map<String, dynamic>? dataToday =
                                      snapToday.data?.data();
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lokasi terakhir",
                                        textAlign: TextAlign.start,
                                        textScaleFactor: 1.1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Purple,
                                        ),
                                      ),
                                      SizedBox(
                                        height: bodyHeight * 0.02,
                                      ),
                                      Text(
                                        user['detailAddress'] != null
                                            ? "${user['detailAddress']['street']}, ${user['detailAddress']['subLocality']}, ${user['detailAddress']['locality']}, ${user['detailAddress']['subAdministrativeArea']}, \n${user['detailAddress']['administrativeArea']}, ${user['detailAddress']['country']}, ${user['detailAddress']['postalCode']},"
                                            : "Belum mendapatkan lokasi.",
                                        textAlign: TextAlign.start,
                                        textScaleFactor: 1.1,
                                        style: TextStyle(
                                          color: Purple,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: bodyHeight * 0.05,
                                      ),
                                      Container(
                                        width: bodyWidth * 1,
                                        height: bodyHeight * 0.06,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          color: Red1,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            controller.getLokasi(
                                              controller.layananC.value,
                                              controller.selectedItem.value,
                                            );
                                            // dashboardController
                                            //     .updateOrderProcessingStatus(
                                            //         true);
                                          },
                                          child: Text(
                                            "Bagikan Lokasi",
                                            textScaleFactor: 1.1,
                                            style: headingBtn.copyWith(
                                                color: Yellow1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return LoadingView();
              }
            });
      }),
    );
  }
}
