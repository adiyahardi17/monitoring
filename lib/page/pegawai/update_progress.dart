import 'package:flutter/material.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/event/event_db.dart';
import 'package:monitoring_pegawai/model/task.dart';

class UpdateProgress extends StatefulWidget {
  final Task task;

  UpdateProgress({required this.task});

  @override
  _UpdateProgressState createState() => _UpdateProgressState();
}

class _UpdateProgressState extends State<UpdateProgress> {
  double progress = 0;

  @override
  void initState() {
    // ignore: unused_local_variable
    int progress = int.parse(widget.task.progress.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Progress'),
        titleSpacing: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            widget.task.taskName ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.task.description ?? '',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${progress.round()}%',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Slider(
            value: progress,
            onChanged: (value) => setState(() => progress = value),
            min: 0,
            max: 100,
            label: '${progress.round()}%',
            divisions: 100,
          ),
          SizedBox(height: 20),
          Material(
            color: Asset.colorAccent,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () {
                EventDB.updateProgress(
                  progress.round(),
                  widget.task.idTask!,
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 12,
                ),
                child: Text(
                  'SIMPAN',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
