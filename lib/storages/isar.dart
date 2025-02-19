import 'package:isar/isar.dart';
import 'models/subtask.dart';
import 'models/task.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppIsarDatabase {
  static late final Isar _instance;

  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    return _instance = await Isar.open(
        [TaskSchema],
        directory: dir.path);
  }

  static Future<List<Task>> getTasks() async {
    return await _instance.writeTxn(
        () async => await _instance.tasks.where().findAll(),
    );
  }

  static Future<void> addTask(Task task) async {
    await _instance.writeTxn(() async => await _instance.tasks.put(task));
  }

  static Future<void> updateTask(int id, Task newTask) async {
    await _instance.writeTxn(() async {
      final task = await _instance.tasks.get(id);
      if (task != null) {
        task
          ..priority = newTask.priority
          ..dateTime = newTask.dateTime
          ..about = newTask.about
          ..description = newTask.description
          ..subtasks = newTask.subtasks
          ..password = newTask.password
          ..isCompleted = newTask.isCompleted;
        return await _instance.tasks.put(task);
      }
    });
  }

  static Future<void> deleteTask(int id) async {
    await _instance.writeTxn(() async => await _instance.tasks.delete(id));
  }

  /*static Future<List<Subtask>> getSubtasks() async {
    return await _instance.writeTxn(
            () async => await _instance.subtasks.where().findAll()
    );
  }*/

  /*static Future<void> addSubtaskToTask(int taskId, Subtask subtask) async {
    await _instance.writeTxn(() async {
      final task = await _instance.tasks.get(taskId);
      if (task != null) {
        task.subtasks.add(subtask);
        await task.subtasks.save();
      }
    });
  }

  static Future<void> updateSubtask(int id, Subtask newSubtask) async {
    await _instance.writeTxn(() async {
      final subtask = await _instance.subtasks.get(id);
      if (subtask != null) {
        subtask
          ..isChecked = newSubtask.isChecked
          ..text = newSubtask.text;
        return await _instance.subtasks.put(subtask);
      }
    });
  }*/
}