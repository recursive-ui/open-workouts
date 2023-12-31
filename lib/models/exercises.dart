import 'dart:math';

import 'package:hive/hive.dart';
import 'package:open_workouts/utilities/maths.dart';

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
  String? imageUrl;
  @HiveField(4)
  String? notes;
  @HiveField(5)
  bool? disabled;

  Exercise(
      {required this.name, this.muscle, this.type, this.imageUrl, this.notes});

  Exercise.fromMap(Map<String, dynamic> map)
      : name = map['name']!,
        muscle = map['muscle'],
        type = map['type'],
        imageUrl = map['imageUrl'],
        notes = map['notes'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'muscle': muscle ?? '',
        'type': type ?? '',
        'imageUrl': imageUrl ?? '',
        'notes': notes ?? '',
      };
}

@HiveType(typeId: 2)
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
  String? exerciseSet;

  Results(
      {required this.date,
      required this.exerciseName,
      this.reps,
      this.measure,
      this.units,
      this.notes,
      this.exerciseSet});

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

  double percentImprovement(Results previous) {
    double repsDiff = 0;
    if (reps != null && previous.reps != null) {
      if (reps!.isNotEmpty && previous.reps!.isNotEmpty) {
        repsDiff = percentDiff(mean(reps!), mean(previous.reps!));
      }
    }
    double measureDiff = 0;
    if (measure != null && previous.measure != null) {
      measureDiff = (measure! - previous.measure!) / previous.measure!;
    }
    return max(repsDiff, measureDiff);
  }

  Results copy() {
    return Results(
      date: date,
      exerciseName: exerciseName,
      reps: reps,
      measure: measure,
      units: units,
      notes: notes,
      exerciseSet: exerciseSet,
    );
  }

  Results.fromMap(Map<String, dynamic> map)
      : date = map['date'],
        exerciseName = map['exerciseName'],
        reps = map['reps'],
        measure = map['measure'],
        units = map['units'],
        notes = map['notes'],
        exerciseSet = map['exerciseSet'];

  Map<String, dynamic> toMap() => {
        'date': date,
        'exerciseName': exerciseName,
        'reps': reps,
        'measure': measure,
        'units': units ?? '',
        'notes': notes ?? '',
        'excerciseSet': exerciseSet ?? '',
      };
}

@HiveType(typeId: 3)
class ExerciseSet extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<int> daysOfWeek = [];
  @HiveField(2)
  List<String> exercises = [];
  @HiveField(3)
  List<int> targetSets = [];

  ExerciseSet({
    required this.name,
    this.daysOfWeek = const [],
    this.exercises = const [],
    this.targetSets = const [],
  });

  String getWeekdayName(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tues';
      case 3:
        return 'Wed';
      case 4:
        return 'Thurs';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return 'Sun';
    }
  }

  String get getStringDaysOfWeek {
    if (daysOfWeek.isEmpty) {
      return '';
    }
    return daysOfWeek.map((e) => getWeekdayName(e)).join(', ');
  }

  int getNextExerciseDay(int weekDay) {
    if (daysOfWeek.isEmpty) {
      return 0;
    }
    return daysOfWeek.firstWhere((e) => e >= weekDay, orElse: () => 6);
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
        daysOfWeek = map['daysOfWeek'],
        exercises = map['exercises'],
        targetSets = map['targetSets'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'daysOfWeek': daysOfWeek,
        'exercises': exercises,
        'targetSets': targetSets,
      };
}
