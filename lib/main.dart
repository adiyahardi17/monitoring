import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/event/event_pref.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/page/admin/dashboard_admin.dart';
import 'package:monitoring_pegawai/page/login.dart';
import 'package:monitoring_pegawai/page/operator/dashboard_operator.dart';
import 'package:monitoring_pegawai/page/pegawai/dashboard_pegawai.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Asset.colorPrimary,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: EventPref.getUser(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          return snapshot.data == null
              ? Login()
              : snapshot.data!.role == 'pegawai'
                  ? DashboardPegawai()
                  : snapshot.data!.role == 'operator'
                      ? DashboardOperator()
                      : DashboardAdmin();
        },
      ),
    );
  }
}
