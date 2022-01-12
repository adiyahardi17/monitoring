class Api {
  static const _host = 'http://localhost:3000';
  static String _job = '$_host/job';
  static String _task = '$_host/task';
  static String _user = '$_host/user';

  static String login = '$_host/login.php';

  /// Job
  static String addJob = '$_job/add_job.php';
  static String deleteJob = '$_job/delete_job.php';
  static String getJobs = '$_job/get_jobs.php';
  static String updateJob = '$_job/update_job.php';

  /// Task
  static String addTask = '$_task/add_task.php';
  static String deleteTask = '$_task/delete_task.php';
  static String getTasks = '$_task/get_tasks.php';
  static String updateTask = '$_task/update_task.php';
  static String updateProgress = '$_task/update_progress.php';

  /// User
  static String addUser = '$_user/add_user.php';
  static String deleteUser = '$_user/delete_user.php';
  static String getUsers = '$_user/get_users.php';
  static String updateUser = '$_user/update_user.php';
}
