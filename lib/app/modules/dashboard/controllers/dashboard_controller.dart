import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  //TODO: Implement DashboardController
  final List<String> titles = [
    'Reguler Grooming Adalah Layanan Grooming Dengan Fasilitas Potong Kuku, Membersihkan Telinga',
    'SPA Layanan Grooming Dengan Menggunakan Shampo Premium dan Juga Mosturaizer Yang Bisa Membuat Kucing Rileks dan Bulu Menjadi Halus',
    'Reguler Grooming Kutu Adalah Layanan Grooming Dengan Fasilitas Potong Kuku, Membersihkan Telinga Menggunakan Shampo Khsus Kutu',
    'Reguler Grooming Jamur Adalah Layanan Grooming Dengan Fasilitas Potong Kuku, Membersihkan Telinga Menggunakan Shampo Khusus Jamur',
  ];

  changePage(int i) {
    currentIndex.value = i;
  }

  var currentIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updateOrderGroomingStatus(String id, String status) async {
    try {
      // Perbarui nilai bidang "status" pesanan di Firestore
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('Order').doc(id);
      await orderRef.update({'status': status});

      // Tambahkan kode lain yang diperlukan setelah memperbarui status pesanan
    } catch (e) {
      // Tangani error jika terjadi
      print('Error updating order status: $e');
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrderDoc() {
    String uid = auth.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('Order')
        .where('uid', isEqualTo: uid)
        .snapshots();
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
