import 'dart:convert';
import 'package:get/get.dart';
import 'package:monitoring_pegawai/config/api.dart';
import 'package:monitoring_pegawai/event/event_pref.dart';
import 'package:monitoring_pegawai/model/job.dart';
import 'package:monitoring_pegawai/model/task.dart';
import 'package:monitoring_pegawai/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:monitoring_pegawai/page/admin/dashboard_admin.dart';
import 'package:monitoring_pegawai/page/operator/dashboard_operator.dart';
import 'package:monitoring_pegawai/page/pegawai/dashboard_pegawai.dart';
import 'package:monitoring_pegawai/widget/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDB {
  static Future<User?> login(String nohp, String pass) async {
    User? user;
    try {
      var response = await http.post(Uri.parse(Api.login), body: {
        'nohp': nohp,
        'pass': pass,
      });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          user = User.fromJson(responseBody['user']);
          EventPref.saveUser(user);
          Info.snackbar('Login Berhasil');
          Future.delayed(Duration(milliseconds: 1700), () {
            Get.off(
              user!.role == 'Pegawai'
                  ? DashboardPegawai()
                  : user.role == 'Operator'
                      ? DashboardOperator()
                      : DashboardAdmin(),
            );
          });
        } else {
          Info.snackbar('Login Gagal');
        }
      } else {
        Info.snackbar('Request Login Gagal');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<List<User>> getUser() async {
    List<User> listUser = [];
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
          var users = responseBody['user'];
          users.forEach((user) {
            listUser.add(User.fromJson(user));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listUser;
  }

  static Future<List<Job>> getJob() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    List<Job> listJob = [];
    try {
      var response = await http.get(
          Uri.parse('http://172.20.10.3:3000/jobs/list_job'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var jobs = responseBody['job'];
          jobs.forEach((job) {
            listJob.add(Job.fromJson(job));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listJob;
  }

  static Future<String> addJob(String id, String name, String salary) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    // List<Job> listJob = [];
    String reason;
    try {
      var response = await http.post(
          Uri.parse('http://172.20.10.3:3000/jobs/add_job'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'id_job': id,
            'job_name': name,
            'salary': salary,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          reason = 'Berhasil Tambah Pekerjaan';
        } else {
          reason = responseBody['reason'];
        }
      } else {
        reason = 'Request Gagal';
      }
    } catch (e) {
      print(e);
      reason = e.toString();
    }
    return reason;
  }

  static Future<void> updateJob(
      String idJob, String name, String salary) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    // List<Job> listJob = [];
    try {
      var response = await http.patch(
          Uri.parse('http://172.20.10.3:3000/jobs/update_job/$idJob'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'id_job': idJob,
            'job_name': name,
            'salary': salary,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Update');
        } else {
          Info.snackbar('Gagal Update');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteJob(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    try {
      var response = await http.delete(
          Uri.parse('http://172.20.10.3:3000/jobs/delete_job/$id'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Delete');
        } else {
          Info.snackbar('Gagal Delete');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  User profile = User(idUser: '', name: '', token: '');
  static Future<String> addUser(String name, String nohp, String pass,
      String role, String address, String idJob) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    String reason;
    try {
      var response = await http.post(
          Uri.parse('http://172.20.10.3:3000/users/add_userbyadm'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'name': name,
            'nohp': nohp,
            'pass': pass,
            'role': role,
            'address': address,
            'id_job': idJob,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          reason = 'Berhasil Tambah $role';
        } else {
          reason = responseBody['reason'];
        }
      } else {
        reason = 'Request Gagal';
      }
    } catch (e) {
      print(e);
      reason = e.toString();
    }
    return reason;
  }

  static Future<void> updateUserbyadm(String idUser, String name, String nohp,
      String role, String address, String idJob) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    try {
      var response = await http.patch(
          Uri.parse(
              'http://172.20.10.3:3000/users/update_userbyadm/$idUser'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'name': name,
            'nohp': nohp,
            'role': role,
            'address': address,
            'id_job': idJob,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Update $role');
        } else {
          Info.snackbar('Gagal Update $role');
        }
      } else {
        Info.snackbar('Request Gagal');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateUserbyop(String idUser, String name, String nohp,
      String role, String address, String idJob) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    try {
      var response = await http.patch(
          Uri.parse('http://172.20.10.3:3000/users/update_userbyop/$idUser'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'name': name,
            'nohp': nohp,
            'role': role,
            'address': address,
            'id_job': idJob,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Update $role');
        } else {
          Info.snackbar('Gagal Update $role');
        }
      } else {
        Info.snackbar('Request Gagal');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteUser(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    try {
      var response = await http.delete(
          Uri.parse('http://172.20.10.3:3000/users/delete_userbyadm/$id'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Delete');
        } else {
          Info.snackbar('Gagal Delete');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Task>> getTask(String idPegawai) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    List<Task> listTask = [];
    try {
      var response = await http.get(
          Uri.parse('http://172.20.10.3:3000/tasks/list_task'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          var tasks = responseBody['task'];
          tasks.forEach((task) {
            listTask.add(Task.fromJson(task));
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listTask;
  }

  static Future<String> addTask(
      String taskName, String description, String idPegawai) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    String reason;
    try {
      var response = await http.post(
          Uri.parse('http://172.20.10.3:3000/tasks/add_task'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'id_pegawai': idPegawai,
            'task_name': taskName,
            'description': description,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          reason = 'Berhasil Tambah Tugas';
        } else {
          reason = 'Gagal Tambah Tugas';
        }
      } else {
        reason = 'Request Gagal';
      }
    } catch (e) {
      print(e);
      reason = e.toString();
    }
    return reason;
  }

  static Future<void> updateTask(
      String taskName, String description, String idTask) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    // List<Job> listJob = [];
    try {
      var response = await http.patch(
          Uri.parse('http://172.20.10.3:3000/tasks/update_task/$idTask'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'task_name': taskName,
            'description': description,
            'id_task': idTask,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Update Tugas');
        } else {
          Info.snackbar('Gagal Update Tugas');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteTask(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    try {
      var response = await http.delete(
          Uri.parse('http://172.20.10.3:3000/tasks/delete_task/$id'),
          headers: <String, String>{
            // 'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: {
            'id_task': id,
          });
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Delete');
        } else {
          Info.snackbar('Gagal Delete');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateProgress(int progress, String idTask) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('user');
    print(data);
    var profile = User.fromJson(jsonDecode(data!));
    try {
      var response = await http.patch(
          Uri.parse('http://172.20.10.3:3000/tasks/update_progress/$idTask'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${profile.token}'
          },
          body: jsonEncode({
            'progress': progress,
          }));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          Info.snackbar('Berhasil Update Progress');
        } else {
          Info.snackbar('Gagal Update Progress');
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
