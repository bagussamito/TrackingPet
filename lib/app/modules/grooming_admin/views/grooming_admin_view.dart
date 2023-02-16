import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/grooming_admin_controller.dart';

class GroomingAdminView extends GetView<GroomingAdminController> {
  const GroomingAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GroomingAdminView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'GroomingAdminView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
