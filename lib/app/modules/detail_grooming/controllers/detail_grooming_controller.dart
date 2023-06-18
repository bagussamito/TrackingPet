import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../dashboard/controllers/dashboard_controller.dart';

class DetailGroomingController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxInt currentStep = 0.obs;
  final RxList<String> steps = <String>[].obs;

  StreamSubscription<DocumentSnapshot>? _dataSubscription;

  void fetchSteps(String id) {
    _dataSubscription?.cancel();
    _dataSubscription = getDataGroomingUser(id).listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        steps.value = [
          data['step0'] ?? '',
          data['step1'] ?? '',
          data['step2'] ?? '',
          data['step3'] ?? '',
        ];
      } else {
        steps.clear();
      }
    }, onError: (error) {
      print('Error fetching steps: $error');
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDataGroomingUser(
      String id) {
    final user = firestore.collection("Tracking").doc(id);
    return user.snapshots();
  }

  void goToNextStep() {
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  @override
  void onClose() {
    _dataSubscription?.cancel();
    super.onClose();
  }
}
