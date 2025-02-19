import 'package:isar/isar.dart';
import 'package:plinplanerko/storages/models/subtask.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  int? priority;
  DateTime? dateTime;
  String? about;
  String? description;
  String? password;
  bool? isCompleted;
  List<Subtask>? subtasks;
}

