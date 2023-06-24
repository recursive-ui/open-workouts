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

List<dynamic>? getNextExerciseSet() {
  ExerciseSet nextSet;
  Box<Program> programsBox = Hive.box<Program>('programs');
  List<Program> currentPrograms =
      programsBox.values.where((p) => p.isCurrent == true).toList();

  if (currentPrograms.isEmpty) {
    List<Program> currentPrograms = programsBox.values.toList();
    if (currentPrograms.isEmpty) {
      return null;
    }
  }

  int dayOfWeek = DateTime.now().weekday;
  Program program = currentPrograms[0];
  List<ExerciseSet>? exerciseSets = program.exerciseSets;

  if (exerciseSets == null || exerciseSets.isEmpty) {
    return null;
  }

  List<ExerciseSet>? nextSets =
      exerciseSets.where((e) => e.dayOfWeek >= dayOfWeek).toList();
  List<int> daysOfWeek = exerciseSets.map((e) => e.dayOfWeek).toList();

  if (nextSets.isEmpty) {
    nextSet = exerciseSets[daysOfWeek.indexOf(daysOfWeek.reduce(min))];
  } else {
    List<int> nextDaysOfWeek = nextSets.map((e) => e.dayOfWeek).toList();
    int nextDayofWeek = nextDaysOfWeek.reduce(min);
    nextSet = exerciseSets[daysOfWeek.indexOf(nextDayofWeek)];
  }
  return [program, nextSet];
}
