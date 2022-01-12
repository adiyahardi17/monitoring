import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/controller/c_user.dart';
import 'package:monitoring_pegawai/event/event_db.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/page/monitoring/detail_profile.dart';
import 'package:monitoring_pegawai/page/operator/add_update_pegawai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPegawai extends StatefulWidget {
  @override
  _ListPegawaiState createState() => _ListPegawaiState();
}

class _ListPegawaiState extends State<ListPegawai> {
  CUser _cUser = Get.put(CUser());
  List<User> _listUser = [];

  User profile = User(idUser: '', name: '', token: '');

  // void getPegawai() async {
  //   _listUser = await EventDB.getUser('Pegawai');
  //   setState(() {});
  // }

  Future<void> getPegawai() async {
    await getPref();
    final response = await http.get(
        Uri.parse('http://172.20.10.3:3000/users/detail_listpegawai'),
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
      throw Exception('Gagal menampilkan list pegawai');
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
        Get.to(DetailProfile(user: user))?.then((value) => getPegawai());
        break;
      case 'update':
        Get.to(AddUpdatePegawai(user: user))?.then((value) => getPegawai());
        break;
      case 'delete':
        EventDB.deleteUser(user.idUser!).then((value) => getPegawai());
        break;
    }
  }

  @override
  void initState() {
    getPegawai();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _listUser.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70),
                itemCount: _listUser.length,
                itemBuilder: (context, index) {
                  User user = _listUser[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Colors.white,
                    ),
                    title: Text(user.name ?? ''),
                    trailing: IconButton(
                      onPressed: () => showOption(user),
                      icon: Icon(Icons.more_vert),
                    ),
                  );
                },
              )
            : Center(child: Text('Kosong')),
        Obx(
          () => _cUser.user.role == 'operator'
              ? Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () => Get.to(AddUpdatePegawai())
                        ?.then((value) => getPegawai()),
                    backgroundColor: Asset.colorAccent,
                    child: Icon(Icons.add),
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}
