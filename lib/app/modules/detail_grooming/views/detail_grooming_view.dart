import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    FirebaseAuth auth = FirebaseAuth.instance;

    // Fetch the steps data when the view is initialized
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.fetchSteps(id);
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: light,
      body: GetBuilder<DetailGroomingController>(
        builder: (c) {
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.getDataGroomingUser(id),
            builder: (context, snapshot) {
              final textScale = MediaQuery.of(context).textScaleFactor;
              final bodyHeight = MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top;
              final bodyWidth = MediaQuery.of(context).size.width;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingView();
              }

              if (snapshot.hasData && snapshot.data!.exists) {
                // Retrieve the data from the snapshot
                var data = snapshot.data!.data();

                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: bodyWidth * 0.05,
                    right: bodyWidth * 0.05,
                    bottom: bodyHeight * 0.01,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Obx(
                        () {
                          if (controller.steps.isNotEmpty) {
                            return Stepper(
                              currentStep: controller.currentStep.value >=
                                      controller.steps.length
                                  ? controller.steps.length - 1
                                  : controller.currentStep.value,
                              onStepContinue: controller.goToNextStep,
                              onStepCancel: controller.goToPreviousStep,
                              steps: [
                                Step(
                                  title: Text('Step 1'),
                                  content: Column(
                                    children: [
                                      Obx(
                                        () {
                                          if (controller.steps[0] != null) {
                                            var step0Data =
                                                controller.steps[0]!;
                                            List<String> splitData =
                                                step0Data.split(' - ');

                                            String berat = splitData[0];
                                            String waktu = splitData[1];

                                            return Column(
                                              children: [
                                                Text('Berat: $berat'),
                                                Text('Waktu: $waktu'),
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
                                  isActive: controller.currentStep.value == 0,
                                ),
                                Step(
                                  title: Text('Step 2'),
                                  content: Column(
                                    children: [
                                      Container(
                                        width: bodyWidth * 0.46,
                                        height: bodyHeight * 0.22,
                                        // Image radius
                                        child: Image.network(
                                          controller.steps[1],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  isActive: controller.currentStep.value == 1,
                                ),
                                Step(
                                  title: Text('Step 3'),
                                  content: Column(
                                    children: [
                                      Obx(
                                        () {
                                          if (controller.steps[2] != null) {
                                            var step0Data =
                                                controller.steps[2]!;
                                            List<String> splitData =
                                                step0Data.split(' - ');

                                            String status = splitData[0];
                                            String waktu = splitData[1];
                                            String foto = splitData[2];

                                            return Column(
                                              children: [
                                                Text('Berat: $status'),
                                                Text('Waktu: $waktu'),
                                                Container(
                                                  width: bodyWidth * 0.46,
                                                  height: bodyHeight * 0.22,
                                                  // Image radius
                                                  child: Image.network(
                                                    '$foto',
                                                    fit: BoxFit.cover,
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
                                  isActive: controller.currentStep.value == 2,
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
              }

              // Show a message if the document doesn't exist
              return const Center(
                child: Text('Document not found.'),
              );
            },
          );
        },
      ),
    );
  }
}
