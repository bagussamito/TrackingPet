import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
import '../controllers/barang_user_controller.dart';

class BarangUserView extends GetView<BarangUserController> {
  BarangUserView({Key? key}) : super(key: key);
  final BarangUserController controller = Get.put(BarangUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.getBarangDoc(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingView();
              }
              if (snap.hasData) {
                var listAllDocs = snap.data!;

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
                                width: bodyWidth * 0.9,
                                height: bodyHeight * 0.085,
                                child: TextFormField(
                                  controller: controller.searchController,
                                  onChanged: (value) =>
                                      controller.searchQuery.add(value),
                                  style: TextStyle(color: Purple),
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
                            ],
                          ),
                          listAllDocs.docs.length == 0
                              ? Center(
                                  child: Text('TIDAK ADA DATA'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      bottom: bodyHeight * 0.005,
                                      top: bodyHeight * 0.01),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snap.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        snap.data!.docs[index].data();

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: bodyHeight * 0.001),
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
                                                      data["foto_barang"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data['nama_barang'],
                                                  textAlign: TextAlign.start,
                                                  textScaleFactor: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Purple,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: bodyHeight * 0.007,
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
                                                      "Rp : ",
                                                      textAlign:
                                                          TextAlign.start,
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Purple,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['harga_barang'],
                                                      textAlign:
                                                          TextAlign.start,
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Purple,
                                                      ),
                                                    ),
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
