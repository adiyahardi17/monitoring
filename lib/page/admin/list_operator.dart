import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/event/event_db.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/page/admin/add_update_operator.dart';
import 'package:monitoring_pegawai/page/monitoring/detail_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOperator extends StatefulWidget {
  @override
  _ListOperatorState createState() => _ListOperatorState();
}

class _ListOperatorState extends State<ListOperator> {
  List<User> _listUser = [];

  User profile = User(idUser: '', name: '', token: '');

  Future<void> getOperator() async {
    await getPref();
    final response = await http.get(
        Uri.parse('http://172.20.10.3:3000/users/detail_listoperator'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${profile.token}'
        });

    if (response.statusCode == 200) {
      // return User.fromJson(jsonDecode(response.body));
      List<User> _user = [];
      var data = jsonDecode(response.body);
      data.forEach((isi) => {_user.add(User.fromJson(isi))});
      print(_user.length);
      setState(() {
        _listUser = _user;
      });
    } else {
      throw Exception('Gagal menampilkan list operator');
    }
  }

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    setState(() {
      profile = User.fromJson(jsonDecode(data!));
    });
  }

  void showOption(User user) async {
    var result = await Get.dialog(
        SimpleDialog(
          children: [
            ListTile(
              onTap: () => Get.back(result: 'detail'),
              title: Text('Detail'),
            ),
            ListTile(
              onTap: () => Get.back(result: 'update'),
              title: Text('Update'),
            ),
            ListTile(
              onTap: () => Get.back(result: 'delete'),
              title: Text('Delete'),
            ),
            ListTile(
              onTap: () => Get.back(),
              title: Text('Close'),
            ),
          ],
        ),
        barrierDismissible: false);
    switch (result) {
      case 'detail':
        Get.to(DetailProfile(user: user));
        break;
      case 'update':
        Get.to(AddUpdateOperator(user: user))?.then((value) => getOperator());
        break;
      case 'delete':
        EventDB.deleteUser(user.idUser!).then((value) => getOperator());
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getOperator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Get.to(AddUpdateOperator())?.then((value) => getOperator()),
        backgroundColor: Asset.colorAccent,
        child: Icon(Icons.add),
      ),
      body: Container(
          margin: EdgeInsets.all(40),
          child: _listUser.length > 0
              ? ListView.builder(
                  itemCount: _listUser.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showOption(_listUser[index]);
                      },
                      child: Container(
                        child: Text(_listUser[index].name ?? ''),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        padding: EdgeInsets.only(
                            left: 18, top: 8, right: 8, bottom: 18),
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 250),
                    Center(
                      child: Text('Kosong'),
                    ),
                  ],
                )),
    );
  }
}
