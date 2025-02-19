part of 'task_cubit.dart';

class TaskState extends Equatable {
  const TaskState({
    this.id,
    this.priority = 1,
    this.dateTime,
    this.about = '',
    this.description = '',
    this.subtasks = const [],
    this.password = '',
    this.isCompleted = false,
  });

  final int? id;
  final int priority;
  final DateTime? dateTime;
  final String about;
  final String description;
  final List<Subtask> subtasks;
  final String password;
  final bool isCompleted;

  factory TaskState.fromIsarModel(Task task) {
    return TaskState(
      id: task.id,
      priority: task.priority ?? 1,
      dateTime: task.dateTime,
      about: task.about ?? '',
      description: task.description ?? '',
      subtasks: task.subtasks ?? [],
      password: task.password ?? '',
      isCompleted: task.isCompleted ?? false,
    );
  }

  @override
  List<Object?> get props => [id, priority, dateTime, about, description, subtasks, password, isCompleted];

  TaskState copyWith({
    int? id,
    int? priority,
    DateTime? dateTime,
    String? about,
    String? description,
    List<Subtask>? subtasks,
    String? password,
    bool? isCompleted,
  }) {
    return TaskState(
      id: id ?? this.id,
      priority: priority ?? this.priority,
      dateTime: dateTime ?? this.dateTime,
      about: about ?? this.about,
      description: description ?? this.description,
      subtasks: subtasks ?? this.subtasks,
      password: password ?? this.password,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Task toIsarModel() {
    return Task()
      ..priority = priority
      ..dateTime = dateTime
      ..about = about
      ..description = description
      ..subtasks = subtasks
      ..password = password
      ..isCompleted = isCompleted;
  }
}

