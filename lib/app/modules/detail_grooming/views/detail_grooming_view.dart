import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: light,
      body: GetBuilder<DetailGroomingController>(builder: (c) {
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.getDataGroomingUser(id),
          builder: (context, snap) {
            final textScale = MediaQuery.of(context).textScaleFactor;
            final bodyHeight = MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top;
            final bodyWidth = MediaQuery.of(context).size.width;

            if (snap.connectionState == ConnectionState.waiting) {
              return LoadingView();
            }
            if (!snap.data!.exists) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: bodyWidth * 0.05,
                  right: bodyWidth * 0.05,
                  bottom: bodyHeight * 0.01,
                ),
                child: Column(
                  children: [
                    // Obx(
                    //   () {
                    //     if (controller.steps.isNotEmpty) {
                    //       return Stepper(
                    //         currentStep: controller.steps.length - 1,
                    //         controlsBuilder: (BuildContext context,
                    //             {VoidCallback? onStepContinue,
                    //             VoidCallback? onStepCancel}) {
                    //           return Row(
                    //             children: <Widget>[
                    //               ElevatedButton(
                    //                 onPressed: onStepContinue,
                    //                 child: Text('Continue'),
                    //               ),
                    //               SizedBox(width: 16.0),
                    //               ElevatedButton(
                    //                 onPressed: onStepCancel,
                    //                 child: Text('Cancel'),
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //         steps:
                    //             List.generate(controller.steps.length, (index) {
                    //           return Step(
                    //             title: Text('Step ${index + 1}'),
                    //             content: Text(controller.steps[index]),
                    //             isActive: index == controller.steps.length - 1,
                    //           );
                    //         }),
                    //       );
                    //     } else {
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              );
            }

            return SizedBox.shrink();
            // Add the necessary code for the other condition(s) here
          },
        );
      }),
    );
  }
}
