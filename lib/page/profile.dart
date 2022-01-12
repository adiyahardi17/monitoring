import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/controller/c_user.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    User user = User();
    CUser _cUser = Get.put(CUser());

  @override
  void initState() {
    super.initState();
    getProfile();
  }

 Future<void> getProfile() async {
    // List<User> listUser = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    // List<User> listUser = [];
    try {
      var response = await http.get(
          Uri.parse('http://172.20.10.3:3000/users/detail_user'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          setState(() {
            user = User.fromJson(responseBody['data']);
          });
        }
      }
    } catch (e) {
      print(e);
    }
    throw Exception("gagal");
  }

  @override
  Widget build(BuildContext context) {
    var styleText = TextStyle(
      fontSize: 18,
    );
    return ListView(
      children: [
        ListTile(
          tileColor: Asset.colorSecondary,
          title: Text('Profile'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('Nama : ${user.name}', style: styleText),
              SizedBox(height: 8),
              Text('No.HP : ${user.nohp}', style: styleText),
              SizedBox(height: 8),
              Text('Alamat : ${user.address}', style: styleText),
              SizedBox(height: 30),
            ],
          ),
        ),
        ListTile(
          tileColor: Asset.colorSecondary, 
          title: Text('Pekerjaan'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('Nama Pekerjaan: ${user.idJob}',
                  style: styleText),
              SizedBox(height: 8),
              Text('Gaji : ${user.salary}', style: styleText),
            ],
          ),
        ),
      ],
    );
  }
}
