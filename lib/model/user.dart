class User {
  String? idUser;
  String? idPegawai;
  String? idTask;
  String? name;
  String? nohp;
  String? pass;
  String? role;
  String? address;
  String? idJob;
  String? jobName;
  int? salary;
  String? token;

  User({
    this.address,
    this.idJob,
    this.idUser,
    this.idPegawai,
    this.idTask,
    this.jobName,
    this.name,
    this.nohp,
    this.pass,
    this.role,
    this.salary,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      address: json['address'],
      idJob: json['id_job'],
      idUser: json['_id'],
      idPegawai: json['id_pegawai'],
      idTask: json['id_task'],
      jobName: json['job_name'],
      name: json['name'],
      nohp: json['nohp'],
      pass: json['pass'],
      role: json['role'],
      salary: json['salary'],
      token: json['token']);

  Map<String, dynamic> toJson() => {
        'address': this.address,
        'id_job': this.idJob,
        'id_user': this.idUser,
        'id_pegawai': this.idPegawai,
        'id_task': this.idTask,
        'job_name': this.jobName,
        'name': this.name,
        'nohp': this.nohp,
        'pass': this.pass,
        'role': this.role,
        'salary': this.salary,
        'token': this.token
      };
}
