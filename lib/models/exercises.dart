import 'package:hive/hive.dart';

part 'exercises.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String? muscle;
  @HiveField(2)
  String? type;
  @HiveField(3)
  String? level;
  @HiveField(4)
  String? imageUrl;
  @HiveField(5)
  String? notes;
  @HiveField(6)
  bool? disabled;

  Exercise(
      {required this.name,
      this.muscle,
      this.type,
      this.level,
      this.imageUrl,
      this.notes});

  Exercise.fromMap(Map<String, dynamic> map)
      : name = map['name']!,
        muscle = map['muscle'],
        type = map['type'],
        level = map['level'].toString(),
        imageUrl = map['imageUrl'],
        notes = map['notes'];

  Map<String, dynamic> toMap() => {
        'name': name,
        if (muscle != null) 'muscle': muscle!,
        if (type != null) 'muscleGroup': type!,
        if (level != null) 'level': level!,
        if (imageUrl != null) 'imageUrl': imageUrl!,
        if (notes != null) 'lastName': notes!,
      };
}

@HiveType(typeId: 2)
class Program extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<ExerciseSet>? exerciseSets;
  @HiveField(2)
  bool? isCurrent = false;

  Program({required this.name, this.exerciseSets, this.isCurrent = false});

  Program.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        isCurrent = map['isCurrent'],
        exerciseSets = map['exerciseSets'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'isCurrent': isCurrent,
        if (exerciseSets != null) 'exerciseSets': exerciseSets,
      };
}

@HiveType(typeId: 3)
class Results extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  String exerciseName;
  @HiveField(2)
  List<int>? reps;
  @HiveField(3)
  double? measure;
  @HiveField(4)
  String? units;
  @HiveField(5)
  String? notes;
  @HiveField(6)
  String? program;

  Results({required this.date, required this.exerciseName, this.program});

  int get sets {
    if (reps != null) {
      return reps!.length;
    }
    return 0;
  }

  set sets(int newSets) {
    if (reps != null) {
      reps = [
        ...reps!.take(newSets),
        for (var i = reps!.length; i < newSets; i++) 0
      ];
    } else {
      reps = List<int>.filled(newSets, 0);
    }
  }

  Results.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        exerciseName = map['exerciseName'],
        reps = map['reps'],
        measure = map['measure'],
        units = map['units'],
        notes = map['notes'],
        program = map['program'];

  Map<String, dynamic> toMap() => {
        'date': date,
        'exerciseName': exerciseName,
        if (reps != null) 'reps': reps,
        if (measure != null) 'measure': measure,
        if (units != null) 'units': units,
        if (notes != null) 'notes': notes,
        if (program != null) 'program': program,
      };
}

@HiveType(typeId: 4)
class ExerciseSet extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  int dayOfWeek;
  @HiveField(2)
  List<String> exercises = [];
  @HiveField(3)
  List<int> targetSets = [];

  ExerciseSet({this.name = '', this.dayOfWeek = 0});

  String getWeekdayName() {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  void addExercise({required String name, int target = 3}) {
    exercises.add(name);
    targetSets.add(target);
  }

  void updateReps({required String name, required int target}) {
    int idx = exercises.indexOf(name);
    targetSets[idx] = target;
  }

  void removeExercise(String name) {
    int idx = exercises.indexOf(name);
    exercises.removeAt(idx);
    targetSets.removeAt(idx);
  }

  void removeAt(int idx) {
    exercises.removeAt(idx);
    targetSets.removeAt(idx);
  }

  ExerciseSet.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        dayOfWeek = map['dayOfWeek'],
        exercises = map['exercises'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'dayOfWeek': dayOfWeek,
        'exercises': exercises,
        'targetSets': targetSets,
      };
}
