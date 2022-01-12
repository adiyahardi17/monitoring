import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/route_manager.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/event/event_db.dart';
import 'package:monitoring_pegawai/model/job.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/page/admin/add_update_job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPekerjaan extends StatefulWidget {
  @override
  _ListPekerjaanState createState() => _ListPekerjaanState();
}

class _ListPekerjaanState extends State<ListPekerjaan> {
  List<Job> _listJob = [];

  User profile = User(idJob: '', jobName: '');

  // void getJob() async {
  //   _listJob = await EventDB.getJob();
  //   setState(() {});
  // }

  Future<void> getJob() async {
    await getPref();
    final response = await http.get(
        Uri.parse('http://172.20.10.3:3000/jobs/list_job'),
        headers: <String, String>{
          // 'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${profile.token}'
        });

    if (response.statusCode == 200) {
      // return User.fromJson(jsonDecode(response.body));
      List<Job> _job = [];
      var data = jsonDecode(response.body)["job"];
      data.forEach((isi) => {_job.add(Job.fromJson(isi))});
      print(_job.length);
      setState(() {
        _listJob = _job;
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

  void showOption(Job job) async {
    var result = await Get.dialog(
        SimpleDialog(
          children: [
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
      case 'update':
        Get.to(AddUpdateJob(job: job))?.then((value) => getJob());
        break;
      case 'delete':
        EventDB.deleteJob(job.idJob!).then((value) => getJob());
        break;
    }
  }

  @override
  void initState() {
    getJob();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _listJob.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(
                  bottom: 70,
                ),
                itemCount: _listJob.length,
                itemBuilder: (context, index) {
                  Job job = _listJob[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                      backgroundColor: Colors.white,
                    ),
                    title: Text(job.jobName ?? ''),
                    subtitle: Text(job.salary.toString()),
                    trailing: IconButton(
                      onPressed: () => showOption(job),
                      icon: Icon(Icons.more_vert),
                    ),
                  );
                },
              )
            : Center(child: Text('Kosong')),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => Get.to(AddUpdateJob())?.then((value) => getJob()),
            backgroundColor: Asset.colorAccent,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
