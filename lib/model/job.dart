class Job {
  String? idJob;
  String? jobName;
  int? salary;
  Job({this.idJob, this.jobName, this.salary});

  factory Job.fromJson(Map<String, dynamic> json) => Job(
      idJob: json['id_job'], jobName: json['job_name'], salary: json['salary']);

  Map<String, dynamic> toJson() =>
      {'id_job': this.idJob, 'job_name': this.jobName, 'salary': this.salary};
}
