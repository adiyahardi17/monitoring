import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/controller/c_user.dart';
import 'package:monitoring_pegawai/event/event_pref.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/page/admin/list_operator.dart';
import 'package:monitoring_pegawai/page/monitoring/list_pegawai.dart';
import 'package:monitoring_pegawai/page/admin/list_pekerjaan.dart';
import 'package:monitoring_pegawai/page/login.dart';

class DashboardAdmin extends StatefulWidget {
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  CUser _cUser = Get.put(CUser());
  int _index = 0;
  List<Map> _fragment = [
    {'title': 'Daftar Operator', 'view': ListOperator()},
    {'title': 'Daftar Pegawai', 'view': ListPegawai()},
    {'title': 'Daftar Pekerjaan', 'view': ListPekerjaan()},
  ];

  void getUser() async {
    User? user = await EventPref.getUser();
    if (user != null) {
      _cUser.setUser(user);
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(_fragment[_index]['title']),
      ),
      body: _fragment[_index]['view'],
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Asset.colorSecondary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    _cUser.user.name ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Asset.colorPrimaryDark,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Role : Admin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Asset.colorPrimaryDark,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              setState(() => _index = 0);
              Get.back();
            },
            leading: Icon(
              Icons.people,
              color: Asset.colorPrimaryDark,
            ),
            title: Text(
              'Daftar Operator',
              style: TextStyle(color: Asset.colorPrimaryDark),
            ),
            trailing: Icon(Icons.navigate_next, color: Asset.colorPrimaryDark),
          ),
          ListTile(
            onTap: () {
              setState(() => _index = 1);
              Get.back();
            },
            leading: Icon(
              Icons.people,
              color: Asset.colorPrimaryDark,
            ),
            title: Text(
              'Daftar Pegawai',
              style: TextStyle(color: Asset.colorPrimaryDark),
            ),
            trailing: Icon(Icons.navigate_next, color: Asset.colorPrimaryDark),
          ),
          ListTile(
            onTap: () {
              setState(() => _index = 2);
              Get.back();
            },
            leading: Icon(
              Icons.work,
              color: Asset.colorPrimaryDark,
            ),
            title: Text(
              'Daftar Pekerjaan',
              style: TextStyle(color: Asset.colorPrimaryDark),
            ),
            trailing: Icon(Icons.navigate_next, color: Asset.colorPrimaryDark),
          ),
          ListTile(
            onTap: () {
              Get.back();
              EventPref.clear();
              Get.off(Login());
            },
            leading: Icon(
              Icons.logout,
              color: Asset.colorPrimaryDark,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Asset.colorPrimaryDark),
            ),
            trailing: Icon(Icons.navigate_next, color: Asset.colorPrimaryDark),
          ),
        ],
      ),
    );
  }
}
