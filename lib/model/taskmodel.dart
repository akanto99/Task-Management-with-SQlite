class TaskModel{
  final int status,id;
  final String title, description, startTime, endTime;


  TaskModel({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
});
}