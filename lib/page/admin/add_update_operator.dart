import 'package:flutter/material.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/event/event_db.dart';
import 'package:monitoring_pegawai/model/job.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:monitoring_pegawai/widget/info.dart';

class AddUpdateOperator extends StatefulWidget {
  final User? user;

  AddUpdateOperator({this.user});

  @override
  _AddUpdateJobState createState() => _AddUpdateJobState();
}

class _AddUpdateJobState extends State<AddUpdateOperator> {
  var _formKey = GlobalKey<FormState>();
  var _controllerName = TextEditingController();
  var _controllerNohp = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _controllerAddress = TextEditingController();

  List<Job> _listJob = [];
  String _idJob = '';

  void getJob() async {
    _listJob = await EventDB.getJob();
    _listJob.insert(0, Job(idJob: 'pilih', jobName: 'Pilih', salary: 0));
    _listJob.removeWhere((e) => e.idJob != 'op' || e.idJob == 'ad');
    setState(() {});
  }

  @override
  void initState() {
    getJob();
    if (widget.user != null) {
      _idJob = widget.user!.idJob ?? '';
      _controllerName.text = widget.user!.name ?? '';
      _controllerNohp.text = widget.user!.nohp ?? '';
      _controllerPassword.text = widget.user!.pass ?? '';
      _controllerAddress.text = widget.user!.address ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:
            Text(widget.user == null ? 'Tambah Operator' : 'Update Operator'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ListTile(
              title: Text('Profile'),
              tileColor: Asset.colorSecondary,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) => value == '' ? 'jangan Kosong' : null,
                    controller: _controllerName,
                    decoration: InputDecoration(labelText: 'Nama'),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    validator: (value) => value == '' ? 'jangan Kosong' : null,
                    controller: _controllerNohp,
                    decoration: InputDecoration(labelText: 'No.HP'),
                  ),
                  SizedBox(height: 16),
                  if (widget.user == null)
                    TextFormField(
                      enabled: widget.user == null ? true : false,
                      validator: (value) =>
                          value == '' ? 'jangan Kosong' : null,
                      controller: _controllerPassword,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  SizedBox(height: 16),
                  TextFormField(
                    validator: (value) => value == '' ? 'jangan Kosong' : null,
                    controller: _controllerAddress,
                    decoration: InputDecoration(labelText: 'Alamat'),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            ListTile(
              title: Text('Pekerjaan'),
              tileColor: Asset.colorSecondary,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: _idJob == '' ? null : _idJob,
                    onChanged: (value) {
                      setState(() {
                        _idJob = value!;
                      });
                    },
                    items: _listJob
                        .map((e) => DropdownMenuItem(
                              child: Text(e.jobName!),
                              value: e.idJob,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      print(_formKey.currentState!.validate());
                      if (_formKey.currentState!.validate()) {
                        if (widget.user == null) {
                          String message = await EventDB.addUser(
                            _controllerName.text,
                            _controllerNohp.text,
                            _controllerPassword.text,
                            'operator',
                            _controllerAddress.text,
                            _idJob,
                          );
                          Info.snackbar(message);
                          if (message.contains('Berhasil')) {
                            _controllerName.clear();
                            _controllerNohp.clear();
                            _controllerPassword.clear();
                            _controllerAddress.clear();
                          }
                        } else {
                          EventDB.updateUserbyadm(
                            widget.user!.idUser!,
                            _controllerName.text,
                            _controllerNohp.text,
                            'operator',
                            _controllerAddress.text,
                            _idJob,
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Asset.colorAccent),
                      foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.black),
                    ),
                    child: Text('SIMPAN'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
