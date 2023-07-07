import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class DashboardAdminController extends GetxController {
  //TODO: Implement DashboardHRController

  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  final namabarangC = TextEditingController();
  final hargabarangC = TextEditingController();

  late TextEditingController nomorindukC = TextEditingController();

  final ImagePicker picker = ImagePicker();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  XFile? image;

  // var isPasswordHidden = true.obs;

  Stream<QuerySnapshot<Object?>> getBarangDoc() {
    CollectionReference barang = firestore.collection("Barang");

    return barang.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderProses() {
    return firestore
        .collection("Order")
        .where('status', isEqualTo: 'Sedang Diproses Admin')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> orderDone() {
    return firestore
        .collection("Order")
        .where('status', isEqualTo: 'Selesai')
        .snapshots();
  }

  void downloadCatalog() async {
    final pdf = pw.Document();

    var getData = await FirebaseFirestore.instance
        .collection("Order")
        .where('status', isEqualTo: 'Selesai')
        .get();

    List<Map<String, dynamic>> allOrder = [];

    for (var element in getData.docs) {
      allOrder.add(element.data());
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData = List.generate(
            allOrder.length,
            (index) {
              Map<String, dynamic> data = allOrder[index];
              var nama_hewan = data['selected item'];
              var addres = data['lokasi hewan']['address'];
              var name = data['name'];
              var status = data['status'];
              return pw.TableRow(
                children: [
                  // NO
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),
                  // Kode Barang
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "$nama_hewan",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),
                  // Qty
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "$name",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "$status",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),
                  // Typ
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "$addres",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),
                ],
              );
            },
          );

          return [
            pw.Center(
              child: pw.Text(
                "Riwayat Order Grooming",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // NO
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "NO",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Kode Barang
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Nama Hewan",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Nama Barang
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        "Nama Pelanggan",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Status",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Qty
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Alamat",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 6,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    // buat file kosong  di direktori
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/mydocument.pdf';
    final file = File(filePath);

    // memasukkan data bytes -> file kosong
    await file.writeAsBytes(await pdf.save());

    var status = await Permission.manageExternalStorage.request();

    // open file
    if (status.isGranted) {
      // Izin diberikan, lakukan tindakan yang diinginkan
      // Contoh: Generate dan buka file PDF
      if (await file.exists()) {
        final fileDir = file.path;
        final result = await OpenFile.open(filePath);

        if (result.type != ResultType.done) {
          throw 'Tidak dapat membuka file PDF';
        }
      } else {
        throw 'File PDF tidak ditemukan';
      }
    } else if (status.isDenied) {
      // Izin ditolak, tampilkan pesan atau lakukan tindakan lain
      Get.snackbar(
        'Izin Ditolak',
        'Anda telah menolak izin akses penyimpanan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (status.isPermanentlyDenied) {
      // Izin ditolak secara permanen, tampilkan pesan atau lakukan tindakan lain
      Get.dialog(
        AlertDialog(
          title: Text('Izin Ditolak Secara Permanen'),
          content: Text(
            'Anda telah menolak izin akses penyimpanan secara permanen. '
            'Mohon izinkan akses melalui Pengaturan Aplikasi.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Get.back();
              },
              child: Text('Pengaturan Aplikasi'),
            ),
          ],
        ),
      );
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
