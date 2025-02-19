part of 'tasks_cubit.dart';

class TasksState extends Equatable {
  const TasksState({
    this.tasks = const [],
    // this.subtasks = const [],
    this.currentDate,
  });

  final List<TaskState> tasks;
  // final List<SubtaskState> subtasks;
  final DateTime? currentDate;

  @override
  List<Object?> get props => [tasks,  currentDate];

  TasksState copyWith({
    List<TaskState>? tasks,
    // List<SubtaskState>? subtasks,
    DateTime? currentDate,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      // subtasks: subtasks ?? this.subtasks,
      currentDate: currentDate ?? this.currentDate,
    );
  }
}
