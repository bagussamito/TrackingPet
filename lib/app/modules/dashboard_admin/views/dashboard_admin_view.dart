import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_admin_controller.dart';

class DashboardAdminView extends GetView<DashboardAdminController> {
  const DashboardAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DashboardAdminView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DashboardAdminView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
