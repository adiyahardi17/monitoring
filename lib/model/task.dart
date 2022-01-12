class Task {
  String? idTask;
  String? taskName;
  String? description;
  int? progress;
  String? idPegawai;

  Task({
    this.description,
    this.idTask,
    this.idPegawai,
    this.progress,
    this.taskName,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        description: json['description'],
        idTask: json['_id'],
        idPegawai: json['id_pegawai'],
        progress: json['progress'],
        taskName: json['task_name'],
      );

  Map<String, dynamic> toJson() => {
        'description': this.description,
        '_id': this.idTask,
        'id_pegawai': this.idPegawai,
        'progress': this.progress,
        'task_name': this.taskName,
      };
}
