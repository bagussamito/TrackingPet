import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:petshop/app/controllers/fcm_controller.dart';
import 'package:petshop/app/modules/detail_grooming/views/detail_grooming_view.dart';
import 'package:petshop/app/theme/theme.dart';

class GroomingController extends GetxController {
  FCMController fcmController = Get.find<FCMController>();
  FirebaseAuth auth = FirebaseAuth.instance;
  final layananC = "".obs;
  var selectedItem = ''.obs;

  void selectItem(String item) {
    selectedItem.value = item;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final layananValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
  ]);

  Stream<QuerySnapshot<Object?>> getHewanDoc() async* {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colHewan =
        await firestore.collection("Users").doc(uid).collection('Hewan');
    yield* firestore
        .collection("Users")
        .doc(uid)
        .collection("Hewan")
        .snapshots();
  }

  void setLayanan(String layanan) {
    layananC.value = layanan;
    log(layananC.value);
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        "message": Get.snackbar("Kesalahan",
            "Layanan lokasi GPS dimatikan, tidak dapat mendapatkan lokasi device"),
        "error": true
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message": Get.snackbar("Kesalahan", "Izin lokasi ditolak."),
          "error": true
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": Get.snackbar("Kesalahan",
            "Izin lokasi ditolak secara permanen, ubah permintaan izin lokasi pada device."),
        "error": true
      };
    }

    Position position = await Geolocator.getCurrentPosition();
    streamGetPosition();
    // Get.reloadAll();
    return {
      "position": position,
      "message": "Berhasil mendapatkan lokasi device.",
      "error": false
    };
  }

  Stream<Position> streamGetPosition() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 50,
      ),
    );
  }

  void getPositionOnly() async {
    await determinePosition();
  }

  void getPositionAndAddress() async {
    Map<String, dynamic> dataResponse = await determinePosition();
    if (!dataResponse["error"]) {
      Position position = dataResponse['position'];
      // log("${position.latitude} , ${position.latitude}");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks[0].street}, \n${placemarks[0].subLocality}, ${placemarks[0].locality}, \n${placemarks[0].subAdministrativeArea}, \n${placemarks[0].administrativeArea}, ${placemarks[0].country}";
      await updateLokasi(position, address);
    } else {
      Get.defaultDialog(title: "Error", middleText: dataResponse["message"]);
    }
  }

  void getLokasi(String name, String layanan, String selectedItem) async {
    Map<String, dynamic> dataResponse = await determinePosition();
    if (!dataResponse["error"]) {
      Position position = dataResponse['position'];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks[0].street}, \n${placemarks[0].subLocality}, ${placemarks[0].locality}, \n${placemarks[0].subAdministrativeArea}, \n${placemarks[0].administrativeArea}, ${placemarks[0].country}";
      await updateLokasi(position, address);
      await shareloc(position, address, layanan, selectedItem);
    } else {
      Get.defaultDialog(title: "Error", middleText: dataResponse["message"]);
    }
  }

  Future<String?> getAdminToken() async {
    return await fcmController.getAdminToken();
  }

  CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection('Notifications');

  Future<void> sendNotificationToAdmin(name) async {
    String serverKey =
        'AAAA6JsekTQ:APA91bGryI4OESo9Aw6h_MnNep1wp9U4qed2MEA_suEuGeiBUwTYcgKw4RKh93upT1XlX9eUPX0KYoGy6Nurdz1Pok6Sv1nOZG8FNQhrwU_wsHEGYw3goqa_JgenBOR9BWfc0B1iil8b'; // Replace with your actual server key
    String? adminToken = await getAdminToken();

    String title = "Pesanan Grooming Baru";
    String message = "$name Telah Memesan Layanan Grooming";

    // await notificationsRef.add({
    //   'title': title,
    //   'message': message,
    //   'read': false,
    //   'timestamp': DateTime.now(),
    //   'token': adminToken,
    // });

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
          'to': adminToken,
        },
      ),
    );
  }

  Future<void> shareloc(Position position, String address, String layanan,
      String selectedItem) async {
    String uid = auth.currentUser!.uid;
    String? name = auth.currentUser!.displayName;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    var colShareloc = await firestore.collection("Order");

    DateTime now = DateTime.now();

    // Menyimpan data shareloc ke Firestore dengan order ID
    var docShareLoc = await colShareloc.add({
      "todayDate": now.toIso8601String(),
      "uid": uid,
      "selected item": selectedItem,
      "layanan": layanan,
      "status": "Menunggu Diterima Admin",
      "name": name,
      "lokasi hewan": {
        "date": now.toIso8601String(),
        "position": {"lat": position.latitude, "long": position.longitude},
        "address": address,
        "detailAddress": {
          "street": placemarks[0].street,
          "subLocality": placemarks[0].subLocality,
          "locality": placemarks[0].locality,
          "subAdministrativeArea": placemarks[0].subAdministrativeArea,
          "administrativeArea": placemarks[0].administrativeArea,
          "country": placemarks[0].country,
          "postalCode": placemarks[0].postalCode
        }
      },
    });
    await docShareLoc.update({"id": docShareLoc.id});
    await sendNotificationToAdmin(name);
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Yellow1,
      child: Container(
        width: 300,
        height: 210,
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              IconlyLight.tick_square,
              color: Blue1,
              size: 100,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Pemesanan Grooming Sukses',
              style: TextStyle(
                  color: Blue1, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Tunggu Admin Memproses Pesanan Anda !',
              style: TextStyle(
                  color: Blue1, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> updateLokasi(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    firestore.collection("Users").doc(uid).update({
      "position": {"lat": position.latitude, "long": position.longitude},
      "address": address,
      "detailAddress": {
        "street": placemarks[0].street,
        "subLocality": placemarks[0].subLocality,
        "locality": placemarks[0].locality,
        "subAdministrativeArea": placemarks[0].subAdministrativeArea,
        "administrativeArea": placemarks[0].administrativeArea,
        "country": placemarks[0].country,
        "postalCode": placemarks[0].postalCode
      }
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("Users").doc(uid).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamLocationUser() async* {
    String uid = auth.currentUser!.uid;
    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection("Users")
        .doc(uid)
        .collection("Presence")
        .doc(todayID)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamLocationStaff() async* {
    String uid = auth.currentUser!.uid;
    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection("Staff")
        .doc(uid)
        .collection("Presence")
        .doc(todayID)
        .snapshots();
  }
}
