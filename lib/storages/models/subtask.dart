import 'package:isar/isar.dart';
part 'subtask.g.dart';

@embedded
class Subtask {
  String? text;
  bool? isChecked;

  Subtask({
    this.text,
    this.isChecked,
  });

  Subtask copyWith(String? text, bool? isChecked) {
    return Subtask(
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}