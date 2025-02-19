import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:plinplanerko/storages/models/subtask.dart';
import 'package:plinplanerko/storages/models/task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({TaskState? task}) : super(task ?? const TaskState());

  void updatePriority(int value) {
    emit(state.copyWith(priority: value));
  }

  void updateDateTime(DateTime value) {
    emit(state.copyWith(dateTime: value));
  }

  void updateAbout(String value) {
    emit(state.copyWith(about: value));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void updateSubtasks(List<Subtask> value) {
    emit(state.copyWith(subtasks: value));
  }

  /*void updateSubtaskIsChecked(int index, bool value) {
    emit(state.copyWith(subtasks: state.subtasks[index].copyWith(null, value)));
  }*/

  void addSubtask(Subtask value) {
    emit(state.copyWith(subtasks: List.from(state.subtasks)..add(value)));
  }

  void updatePassword(String value) {
    emit(state.copyWith(password: value));
  }

  void updateIsCompleted(bool value) {
    emit(state.copyWith(isCompleted: value));
  }
}