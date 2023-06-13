import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../grooming/controllers/grooming_controller.dart';

class LayananGroomingAdminController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String orderID = '';

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String id) async* {
    var user = firestore.collection("Order").doc(id);
    yield* user.snapshots();
  }

  CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection('Notifications');

  Future<void> sendNotificationToUser(
      String uid, String title, String message) async {
    String serverKey =
        'AAAA6JsekTQ:APA91bGryI4OESo9Aw6h_MnNep1wp9U4qed2MEA_suEuGeiBUwTYcgKw4RKh93upT1XlX9eUPX0KYoGy6Nurdz1Pok6Sv1nOZG8FNQhrwU_wsHEGYw3goqa_JgenBOR9BWfc0B1iil8b'; // Replace with your actual server key

    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    List<String> tokens = [];
    if (userSnapshot.exists && userSnapshot.data() != null) {
      var userData = userSnapshot.data()!;
      if (userData.containsKey('fcmToken') &&
          userData['fcmToken'] is List<dynamic>) {
        tokens = List<String>.from(userData['fcmToken']);
      }
    }

    // Send the notification to the user tokens
    for (String token in tokens) {
      await notificationsRef.add({
        'title': title,
        'message': message,
        'read': false,
        'timestamp': DateTime.now(),
        'token': token,
        'uid': uid,
      });

      // Send the FCM notification using HTTP POST request
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': message,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
            'to': token, // Use 'to' instead of 'registration_ids'
          },
        ),
      );
    }
  }

  RxInt currentStep = 0.obs;

  void goToNextStep({required String id, required String title}) async {
    if (currentStep.value < 2) {
      if (currentStep.value == 0) {
        // Use the value of the step 1 text field
        String textFieldValue = kondisihwnC.text;

        // Get the current clock time
        DateTime currentTime = DateTime.now();
        String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
        jamjemputController.value = formattedTime;

        // Combine the text field value and clock time
        String stepData = '$textFieldValue - $formattedTime';
        addStepperData(
          stepIndex: currentStep.value,
          stepData: stepData,
          id: id,
        );
        String message = 'Admin Memproses Grooming Hewan';
        await sendNotificationToUser(id, title, message);
      } else if (currentStep.value == 1) {
        // Upload the image to Firestore and get the download URL
        if (previewImagestep2.value != null) {
          File imageFile = previewImagestep2.value!;
          String imageUrl = await uploadImageToFirestore(imageFile);
          String stepData = '$imageUrl';
          addStepperData(
            stepIndex: currentStep.value,
            stepData: stepData,
            id: id,
          );
          String message = 'Admin Memproses Grooming Hewan';
          await sendNotificationToUser(id, title, message);
        }
      }

      if (currentStep.value == 1 && previewImagestep2.value == null) {
        // Jika ada isian yang belum diisi pada Step 2
        Get.snackbar(
          'Error',
          'Please select an image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (currentStep.value == 2) {
        // Jika sudah mencapai Step 3, tampilkan snackbar untuk menyelesaikan langkah-langkah
        Get.snackbar(
          'Success',
          'All steps completed!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        currentStep.value++;
      }
    }
  }

  void confirmStep3({required String id, required String title}) async {
    // Lakukan aksi konfirmasi pada step 3
    // Misalnya, simpan data ke database atau lakukan tindakan lainnya
    String stepData = '';
    if (previewImagestep4.value != null) {
      File imageFile = previewImagestep4.value!;
      String imageUrl = await uploadImageToFirestore(imageFile);
      String textFieldValue = step3Controller.text;
      DateTime currentTime = DateTime.now();
      String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
      jamselesaiController.value = formattedTime;
      stepData = '$textFieldValue - $formattedTime - $imageUrl';

      // Tambahkan data ke Firestore

      addStepperData(
        stepIndex: 2,
        stepData: stepData,
        id: id,
      );

      // Setelah konfirmasi selesai, lanjutkan ke step berikutnya
      goToNextStep(id: id, title: title);
    }
  }

  Future<String> uploadImageToFirestore(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Rx<File?> previewImagestep2 = Rx<File?>(null);
  Rx<File?> previewImagestep4 = Rx<File?>(null);

  final step2validator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);
  final step3validator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);
  final step4validator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);

  RxList<String> stepDataList = RxList<String>(["", "", "", ""]);
  RxString jamjemputController = RxString('');
  RxString jamselesaiController = RxString('');

  TextEditingController kondisihwnC = TextEditingController();
  TextEditingController step2Controller = TextEditingController();
  TextEditingController step3Controller = TextEditingController();
  TextEditingController step4Controller = TextEditingController();

  void updateStepData(int stepIndex, String stepData) {
    stepDataList[stepIndex] = stepData;
  }

  void addStepperData({
    required int stepIndex,
    required dynamic stepData,
    required String id,
  }) async {
    try {
      // Dapatkan reference ke dokumen tracking yang sesuai
      DocumentReference trackingDoc = firestore.collection("Tracking").doc(id);

      // Update data langkah sesuai indeks
      DocumentSnapshot<Object?> docSnapshot = await trackingDoc.get();
      Map<String, dynamic>? currentData =
          docSnapshot.data() as Map<String, dynamic>?;

      if (currentData == null) {
        currentData = {};
      }

      // Update the step data in the current document data
      currentData['step$stepIndex'] = stepData;

      // Set the updated document data
      await trackingDoc.set(currentData);

      // Show success message or perform any other actions
      Get.snackbar(
        'Success',
        'Step $stepIndex data added to Firestore',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Print the step data for debugging
      print('Step $stepIndex data: $stepData');
    } catch (error) {
      // Show error message or perform error handling
      Get.snackbar(
        'Error',
        'Failed to add Step $stepIndex data to Firestore',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String get step1Value => jamjemputController.value;
}
