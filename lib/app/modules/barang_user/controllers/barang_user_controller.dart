import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/barangmodel.dart';

class BarangUserController extends GetxController {
  //TODO: Implement DashboardController

  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? image;

  Stream<QuerySnapshot<Map<String, dynamic>>> getBarangDoc() {
    return searchQuery
        .debounceTime(Duration(milliseconds: 300))
        .switchMap((query) {
      if (query.isEmpty) {
        return firestore.collection("Barang").snapshots();
      } else {
        String lowerCaseQuery = query.toLowerCase();
        String upperCaseQuery = query.toUpperCase();
        return firestore
            .collection("Barang")
            .where("nama_barang", isGreaterThanOrEqualTo: query)
            .where("nama_barang", isLessThanOrEqualTo: query + 'z')
            .snapshots();
      }
    });
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> olahSearch;

  final TextEditingController searchController = TextEditingController();
  final BehaviorSubject<String> searchQuery = BehaviorSubject<String>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    searchQuery.add('');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchQuery.close();
    searchController.dispose();
  }

  void increment() => count.value++;
}
