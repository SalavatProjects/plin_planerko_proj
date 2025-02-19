import 'package:bloc/bloc.dart';
import 'package:flagsmith/flagsmith.dart';
import 'task_cubit.dart';
import 'package:plinplanerko/storages/isar.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState());

  Future<void> getTasks() async {
    final tasks = await AppIsarDatabase.getTasks();
    // final subtasks = await AppIsarDatabase.getSubtasks();
    emit(state.copyWith(
      tasks: tasks.map((e) => TaskState.fromIsarModel(e)).toList(),
      // subtasks: subtasks.map((e) => SubtaskState.fromIsarModel(e)).toList(),
    ));
  }

  Future<void> addTask(TaskState task) async {
    await AppIsarDatabase.addTask(task.toIsarModel());
    await getTasks();
  }

  /*Future<List<int>> addSubtasks(List<SubtaskState> subtasks) async {
    List<int> subtaskIds = [];
    for (var subtask in subtasks) {
      final subtaskId = await AppIsarDatabase.addSubtask(subtask.toIsarModel());
      subtaskIds.add(subtaskId);
    }
    await getTasks();
    return subtaskIds;
  }*/



  Future<void> deleteTask(int id) async {
    await AppIsarDatabase.deleteTask(id);
    await getTasks();
  }

  Future<void> updateTask(int id, TaskState task) async {
    await AppIsarDatabase.updateTask(id, task.toIsarModel());
    await getTasks();
  }

  /*Future<void> updateSubtask(int id, SubtaskState subtask) async {
    await AppIsarDatabase.updateSubtask(id, subtask.toIsarModel());
    await getTasks();
  }*/

  void updateCurrentDate(DateTime value) {
    emit(state.copyWith(currentDate: value));
  }
}
