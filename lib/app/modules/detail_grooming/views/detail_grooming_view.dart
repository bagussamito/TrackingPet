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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      Obx(() {
                        if (controller.steps.isNotEmpty) {
                          return Stepper(
                            currentStep: controller.steps.length - 1,
                            steps:
                                List.generate(controller.steps.length, (index) {
                              return Step(
                                title: Text('Step ${index + 1}'),
                                content: Text(controller.steps[index]),
                                isActive: index == controller.steps.length - 1,
                              );
                            }).toList(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
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
