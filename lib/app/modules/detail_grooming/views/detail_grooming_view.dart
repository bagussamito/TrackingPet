import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../controllers/detail_grooming_controller.dart';

class DetailGroomingView extends GetView<DetailGroomingController> {
  DetailGroomingView({Key? key}) : super(key: key);
  final DetailGroomingController controller =
      Get.put(DetailGroomingController());

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;
    var id = user['id'];

    // Fetch the steps data when the view is initialized
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.fetchSteps(id);
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.getDataGroomingUser(id),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingView();
              }
              if (snap.hasData) {
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
                            height: bodyHeight * 0.04,
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
                          Text("Data Monitoring Hewan",
                              textAlign: TextAlign.start,
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Purple,
                                fontSize: 24,
                              )),
                          Obx(
                            () {
                              if (controller.steps.isNotEmpty) {
                                return Stepper(
                                  onStepTapped: (step) =>
                                      controller.currentStep.value = step,
                                  physics: const ClampingScrollPhysics(),
                                  currentStep: controller.currentStep.value >=
                                          controller.steps.length
                                      ? controller.steps.length - 1
                                      : controller.currentStep.value,
                                  onStepContinue: controller.goToNextStep,
                                  onStepCancel: controller.goToPreviousStep,
                                  steps: [
                                    Step(
                                      title: Text(
                                        'Hewan Mulai Digrooming',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Purple),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () {
                                              if (controller.steps.isNotEmpty &&
                                                  controller.steps[0] != null) {
                                                var step0Data =
                                                    controller.steps[0]!;
                                                List<String> splitData =
                                                    step0Data.split(' - ');

                                                String berat = splitData[0];
                                                String waktu = splitData[1];

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Berat:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      berat,
                                                      style: TextStyle(
                                                          color: Purple),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Waktu:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      waktu,
                                                      style: TextStyle(
                                                          color: Purple),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const Text('No data');
                                              }
                                            },
                                          ),
                                          // Add other content widgets for Step 0 if needed
                                        ],
                                      ),
                                      isActive:
                                          controller.currentStep.value == 0,
                                    ),
                                    Step(
                                      title: Text(
                                        'Proses Hewan Digrooming',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Purple),
                                      ),
                                      content: Column(
                                        children: [
                                          Container(
                                            width: bodyWidth * 0.46,
                                            height: bodyHeight * 0.22,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                controller.steps[1],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      isActive:
                                          controller.currentStep.value == 1,
                                    ),
                                    Step(
                                      title: Text(
                                        'Hewan Selesai Digrooming',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Purple),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () {
                                              if (controller.steps.isNotEmpty &&
                                                  controller.steps[2] != null) {
                                                var step0Data =
                                                    controller.steps[2]!;
                                                List<String> splitData =
                                                    step0Data.split(' - ');

                                                String status = splitData[0];
                                                String waktu = splitData[1];
                                                String foto = splitData[2];

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Status:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      status,
                                                      style: TextStyle(
                                                          color: Purple),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Waktu:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      waktu,
                                                      style: TextStyle(
                                                          color: Purple),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      width: bodyWidth * 0.46,
                                                      height: bodyHeight * 0.22,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          '$foto',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const Text('No data');
                                              }
                                            },
                                          ),
                                          // Add other content widgets for Step 0 if needed
                                        ],
                                      ),
                                      isActive:
                                          controller.currentStep.value == 2,
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                print("No data available");
                return LoadingView();
              }
            }));
  }
}
