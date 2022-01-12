import 'dart:convert';
import 'package:monitoring_pegawai/widget/info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/page/admin/dashboard_admin.dart';
import 'package:monitoring_pegawai/page/operator/dashboard_operator.dart';
import 'package:monitoring_pegawai/page/pegawai/dashboard_pegawai.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _controllerNohp = TextEditingController();
  var _controllerPass = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  late SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://172.20.10.3:3000/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nohp': _controllerNohp.text,
        'pass': _controllerPass.text
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
      var user = User.fromJson(jsonDecode(response.body)["data"]);
      await preferences.setString('user', jsonEncode(user));
      print(jsonEncode(user));
      if (user.role == 'admin') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardAdmin()));
      } else if (user.role == 'operator') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardOperator()));
      } else if (user.role == 'pegawai') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DashboardPegawai()));
      }
      Info.snackbar('Login Berhasil');
    } else {
      Info.snackbar('Login Gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              color: Asset.colorPrimary,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                left: 20,
                bottom: 20,
              ),
              child: Text(
                'Hai,\nLogin Dulu',
                style: TextStyle(
                  fontSize: 35,
                  color: Asset.colorPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value == '' ? 'Jangan Kosong' : null,
                      controller: _controllerNohp,
                      style: TextStyle(
                        color: Asset.colorPrimaryDark,
                      ),
                      decoration: InputDecoration(
                        hintText: '089xxxxxxx',
                        hintStyle: TextStyle(
                          color: Asset.colorPrimaryDark,
                        ),
                        fillColor: Asset.colorSecondary,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Asset.colorSecondary,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Asset.colorPrimaryDark,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Asset.colorSecondary,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Asset.colorPrimaryDark,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      validator: (value) =>
                          value == '' ? 'Jangan Kosong' : null,
                      controller: _controllerPass,
                      style: TextStyle(
                        color: Asset.colorPrimaryDark,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '*******',
                        hintStyle: TextStyle(
                          color: Asset.colorPrimaryDark,
                        ),
                        fillColor: Asset.colorSecondary,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Asset.colorSecondary,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Asset.colorPrimaryDark,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Asset.colorSecondary,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Asset.colorPrimaryDark,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Material(
                      color: Asset.colorAccent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // EventDB.login(
                            //     _controllerNohp.text, _controllerPass.text);
                            // _controllerNohp.clear();
                            // _controllerPass.clear();
                            login();
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
