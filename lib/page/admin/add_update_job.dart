import 'package:flutter/material.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/event/event_db.dart';
import 'package:monitoring_pegawai/model/job.dart';
import 'package:monitoring_pegawai/widget/info.dart';

class AddUpdateJob extends StatefulWidget {
  final Job? job;

  AddUpdateJob({this.job});

  @override
  _AddUpdateJobState createState() => _AddUpdateJobState();
}

class _AddUpdateJobState extends State<AddUpdateJob> {
  var _formKey = GlobalKey<FormState>();
  var _controllerIdJob = TextEditingController();
  var _controllerJobName = TextEditingController();
  var _controllerSalary = TextEditingController();

  @override
  void initState() {
    if (widget.job != null) {
      _controllerIdJob.text = widget.job!.idJob!;
      _controllerJobName.text = widget.job!.jobName!;
      _controllerSalary.text = widget.job!.salary.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:
            Text(widget.job == null ? 'Tambah Pekerjaan' : 'Update Pekerjaan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              enabled: widget.job == null ? true : false,
              validator: (value) => value == '' ? 'jangan Kosong' : null,
              controller: _controllerIdJob,
              decoration: InputDecoration(labelText: 'Id Pekerjaan'),
            ),
            SizedBox(height: 16),
            TextFormField(
              validator: (value) => value == '' ? 'jangan Kosong' : null,
              controller: _controllerJobName,
              decoration: InputDecoration(labelText: 'Nama Pekerjaan'),
            ),
            SizedBox(height: 16),
            TextFormField(
              validator: (value) => value == '' ? 'jangan Kosong' : null,
              controller: _controllerSalary,
              decoration: InputDecoration(labelText: 'Gaji'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (widget.job == null) {
                    String message = await EventDB.addJob(
                      _controllerIdJob.text,
                      _controllerJobName.text,
                      _controllerSalary.text,
                    );
                    Info.snackbar(message);
                    if (message.contains('Berhasil')) {
                      _controllerIdJob.clear();
                      _controllerJobName.clear();
                      _controllerSalary.clear();
                    }
                  } else {
                    EventDB.updateJob(
                      _controllerIdJob.text,
                      _controllerJobName.text,
                      _controllerSalary.text,
                    );
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Asset.colorAccent),
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.black),
              ),
              child: Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }
}
