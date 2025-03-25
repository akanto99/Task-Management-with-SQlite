import 'package:path/path.dart';
import 'package:razinsoft_task_management/model/taskmodel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIDColumnName = "id";
  final String _tasksTitleColumnName = "title";
  final String _tasksDescriptionColumnName = "description";
  final String _tasksStartTimeColumnName = "startTime";
  final String _tasksEndTimeColumnName = "endTime";
  final String _tasksStatusColumnName = "status";

  Future<Database> get database async {
    if (_db == null) {
      print("Database is null, initializing...");
      _db = await _initDatabase();
    } else {
      print("Database already initialized.");
    }
    return _db!;
  }


  Future<Database> _initDatabase() async {
    try {
      final databaseDirPath = await getDatabasesPath();
      final databasePath = join(databaseDirPath, "master_db.db");

      print("Database path: $databasePath"); // Debugging line

      return await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) async {
          print("Creating database and tasks table...");
          await db.execute('''
          CREATE TABLE $_tasksTableName (
            $_tasksIDColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_tasksTitleColumnName TEXT NOT NULL,
            $_tasksDescriptionColumnName TEXT NOT NULL,
            $_tasksStartTimeColumnName TEXT NOT NULL,
            $_tasksEndTimeColumnName TEXT NOT NULL,
            $_tasksStatusColumnName INTEGER NOT NULL
          )
        ''');
        },
      );
    } catch (e) {
      print("Database initialization error: $e");
      rethrow;
    }
  }

  Future<void> addTask(String title, String description, String startTime, String endTime) async {
    try {
      final db = await database;

      print("Inserting Task: Title: $title, Description: $description, StartTime: $startTime, EndTime: $endTime");

      await db.insert(_tasksTableName, {
        _tasksTitleColumnName: title,
        _tasksDescriptionColumnName: description,
        _tasksStartTimeColumnName: startTime,
        _tasksEndTimeColumnName: endTime,
        _tasksStatusColumnName: 0,
      });

      print("Task added successfully!");
    } catch (e) {
      print("Error adding task: $e");
      rethrow;
    }
  }


  Future<List<TaskModel>> getTasks() async {

      final db = await database;
      final List<Map<String, dynamic>> data = await db.query(_tasksTableName);
      print("Fetched Tasks: $data");
     List<TaskModel>tasks=data.map((e)=>TaskModel(id: e["id"] as int, status: e["status"] as int, title: e["title"]  as String, description: e["description"] as String, startTime: e["startTime"] as String, endTime: e["endTime"] as String)).toList();
    return tasks;
  }

  Future<void> updateTask(TaskModel task, {int? status}) async {
    final db = await database;

    await db.update(
      _tasksTableName,
      {
        _tasksTitleColumnName: task.title,
        _tasksDescriptionColumnName: task.description,
        _tasksStartTimeColumnName: task.startTime,
        _tasksEndTimeColumnName: task.endTime,
        _tasksStatusColumnName: status ?? task.status,
      },
      where: "$_tasksIDColumnName = ?",
      whereArgs: [task.id],
    );
  }


  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}
