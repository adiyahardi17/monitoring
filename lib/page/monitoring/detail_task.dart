import 'package:flutter/material.dart';
import 'package:monitoring_pegawai/config/asset.dart';
import 'package:monitoring_pegawai/model/task.dart';
import 'package:pie_chart/pie_chart.dart';

class DetailTask extends StatelessWidget {
  final Task task;

  DetailTask({required this.task});

  @override
  Widget build(BuildContext context) {
    double progress = double.parse(task.progress.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
        titleSpacing: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            task.taskName ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            task.description ?? '',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20),
          PieChart(
            dataMap: {
              'Selesai': progress,
              'Belum Selesai': 100 - progress,
            },
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width * 0.5,
            colorList: [
              Asset.colorAccent,
              Asset.colorSecondary,
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 28,
            centerText: '${progress.round()}%',
            legendOptions: LegendOptions(
              showLegends: false,
            ),
            chartValuesOptions: ChartValuesOptions(
              chartValueStyle: TextStyle(
                fontSize: 30,
                color: Asset.colorPrimaryDark,
              ),
              chartValueBackgroundColor: Colors.white,
              showChartValueBackground: true,
              showChartValues: false,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                color: Asset.colorAccent,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 16),
              Text(
                'Selesai',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                color: Asset.colorSecondary,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 16),
              Text(
                'Belum Selesai',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Material(
            elevation: 2,
            color: progress < 100 ? Asset.colorSecondary : Asset.colorAccent,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 12,
              ),
              child: Text(
                progress < 100 ? 'On-Progress' : 'Selesai',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: progress < 100 ? Asset.colorPrimaryDark : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
