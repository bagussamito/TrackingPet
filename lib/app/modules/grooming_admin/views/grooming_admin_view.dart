import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/grooming_admin_controller.dart';

class GroomingAdminView extends GetView<GroomingAdminController> {
  GroomingAdminView({Key? key}) : super(key: key);

  final GroomingAdminController controller = Get.put(GroomingAdminController());

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: light,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamDataOrder(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.active) {
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
                            Text("Daftar Order Grooming",
                                textAlign: TextAlign.start,
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Purple,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: bodyHeight * 0.04,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: bodyHeight * 0.02),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data =
                                snap.data!.docs[index].data();
                            var layanan = data['layanan'];
                            var nama_hewan = data['selected item'];
                            var addres = data['lokasi hewan']['address'];
                            var name = data['name'];
                            var uid = data['uid'];

                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: bodyHeight * 0.015),
                              child: Material(
                                color: Grey1,
                                borderRadius: BorderRadius.circular(30),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                    width: bodyWidth * 1,
                                    height: bodyHeight * 0.35,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: bodyWidth * 0.06,
                                            left: bodyWidth * 0.06,
                                            top: bodyHeight * 0.02,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Tanggal: ",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${DateFormat('d MMMM yyyy', 'id-ID').format(DateTime.parse(data['lokasi hewan']['date']))}",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Layanan yang diambil: ",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                  Text(
                                                    "$layanan",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Nama Hewan: ",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                  Text(
                                                    "$nama_hewan",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Nama Pemesan: ",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                  Text(
                                                    "$name",
                                                    textAlign: TextAlign.start,
                                                    textScaleFactor: 0.9,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: bodyWidth * 0.06,
                                            left: bodyWidth * 0.06,
                                            top: bodyHeight * 0.02,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Lokasi Hewan: ",
                                                textAlign: TextAlign.start,
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Purple,
                                                ),
                                              ),
                                              Text(
                                                "$addres",
                                                textAlign: TextAlign.start,
                                                textScaleFactor: 0.9,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Purple,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await dashboardController
                                                      .updateOrderGroomingStatus(
                                                          data['id'],
                                                          'Diterima');
                                                  Get.toNamed(
                                                      Routes
                                                          .LAYANAN_GROOMING_ADMIN,
                                                      arguments: data);

                                                  await controller
                                                      .sendNotificationToUser(
                                                    uid,
                                                    'Pesanan Layanan Grooming Diterima Oleh Admin',
                                                    'Selamat Admin Sedang Memproses Layanan Anda!',
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.check,
                                                  color: Purple,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
          }),
    );
  }
}
