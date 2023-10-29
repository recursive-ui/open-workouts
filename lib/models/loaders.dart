import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:permission_handler/permission_handler.dart';

void loadExercisesFromJson({jsonURL, bool isLocal = false}) async {
  final String response;
  if (isLocal) {
    response = await rootBundle.loadString(jsonURL);
  } else {
    response = '{}';
  }
  final data = await json.decode(response);
  Box<Exercise> exerciseBox = Hive.box<Exercise>('exercises');
  data.forEach((e) {
    e.removeWhere((key, value) =>
        key == null || value == null || value == '' || value == 'null');
    exerciseBox.add(Exercise.fromMap(e));
  });
}

Future<void> clearExerciseBox() async {
  Box<Exercise> box = Hive.box<Exercise>('exercises');
  await box.clear();
}

Future<void> exportToJson() async {
  var status = await Permission.storage.status;

  if (status.isGranted) {
    final directory =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))!
            .first;
    File file = File("${directory.path}/test.json");

    Map<dynamic, Exercise> map = Hive.box<Exercise>('exercises').toMap();
    List<Map<String, dynamic>> boxBck = [];
    map.forEach((key, value) {
      boxBck.add(value.toMap());
    });
    String outJson = json.encode(boxBck);
    // File jsonFile = File(file);
    await file.writeAsString(outJson);
    print('exported');
  } else {
    print('failed');
  }
}

ExerciseSet? getNextExerciseSet() {
  ExerciseSet nextSet;
  List<ExerciseSet> sets = Hive.box<ExerciseSet>('sets').values.toList();
  sets.retainWhere((e) => e.daysOfWeek.isNotEmpty);

  if (sets.isEmpty || sets.where((e) => e.daysOfWeek.isNotEmpty).isEmpty) {
    return null;
  }

  int dayOfWeek = DateTime.now().weekday;
  List<ExerciseSet>? nextSets =
      sets.where((e) => e.getNextExerciseDay(dayOfWeek) >= dayOfWeek).toList();
  List<int> daysOfWeek = sets.map((e) => e.daysOfWeek.reduce(min)).toList();

  if (nextSets.isEmpty) {
    nextSet = sets[daysOfWeek.indexOf(daysOfWeek.reduce(min))];
  } else {
    List<int> nextDaysOfWeek =
        nextSets.map((e) => e.getNextExerciseDay(dayOfWeek)).toList();
    int nextDayofWeek = nextDaysOfWeek.reduce(min);
    nextSet = sets[daysOfWeek.indexOf(nextDayofWeek)];
  }
  return nextSet;
}
