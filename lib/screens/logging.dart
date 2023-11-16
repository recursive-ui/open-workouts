import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/log_exercise.dart';

class LoggingPage extends StatefulWidget {
  final ExerciseSet? set;
  const LoggingPage({
    Key? key,
    this.set,
  }) : super(key: key);

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  final List<ExerciseSet> exerciseSets =
      Hive.box<ExerciseSet>('sets').values.toList();
  final Box<Results> resultsBox = Hive.box<Results>('results');
  final Box<Results> curResultsBox = Hive.box<Results>('currentResults');
  final DateFormat formatter = DateFormat('dd-MM');
  final List<Exercise> exercises =
      Hive.box<Exercise>('exercises').values.toList();
  ExerciseSet? selectedSet;
  Exercise? selectedExercise;
  late DateTime now;
  late DateTime date = DateTime.now();
  bool modifiedResults = false;
  List<String> resultsNames = [];

  void updateSet(ExerciseSet? newSet) async {
    if (newSet != null) {
      Map<dynamic, Results> newResults = {
        for (String name in newSet.exercises)
          name: Results(
            date: date,
            exerciseName: name,
            exerciseSet: newSet.name,
          ),
      };

      await curResultsBox.clear();
      await curResultsBox.putAll(newResults);

      setState(() {
        modifiedResults = false;
        selectedSet = newSet;
        resultsNames = List<String>.from(curResultsBox.keys);
      });
    }
  }

  void addNewExerciseButton() {
    selectedExercise = null;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: ThemeColors.kLightPurple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<Exercise>(
                    isExpanded: true,
                    isDense: false,
                    hint: const Text('Add an exercise'),
                    items: exercises.map((e) {
                      return DropdownMenuItem<Exercise>(
                        value: e,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.muscle ?? '',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: ThemeColors.kPurple,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              e.name,
                              style: const TextStyle(fontSize: 16.0),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => selectedExercise = val,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: ThemeColors.kLightMint,
                  radius: 20,
                  child: IconButton(
                    onPressed: addNewExercise,
                    icon: const Icon(Icons.add),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void addNewExercise() {
    if (selectedExercise != null) {
      Results newResult = Results(
        date: date,
        exerciseName: selectedExercise!.name,
        exerciseSet: selectedSet?.name,
      );
      newResult.sets = 3;
      curResultsBox.put(selectedExercise!.name, newResult);
      setState(() {
        resultsNames = List<String>.from(curResultsBox.keys);
      });
      Navigator.pop(context);
    }
  }

  void logResult(String exerciseName) {
    Results? resultToAdd = curResultsBox.get(exerciseName);
    if (resultToAdd != null) {
      resultsBox.add(resultToAdd);
      curResultsBox.delete(exerciseName);
    }
    setState(() {
      resultsNames = List<String>.from(curResultsBox.keys);
    });
  }

  void removeResult(String exerciseName) {
    curResultsBox.delete(exerciseName);
    setState(() {
      resultsNames = List<String>.from(curResultsBox.keys);
    });
  }

  void updateDate(DateTime newDate) {
    Map<String, Results> newResults =
        Map<String, Results>.from(curResultsBox.toMap());
    for (Results result in newResults.values) {
      result.date = date;
    }

    curResultsBox.clear();
    curResultsBox.putAll(newResults);
    setState(() {
      resultsNames = List<String>.from(curResultsBox.keys);
    });
  }

  @override
  void initState() {
    super.initState();

    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);

    selectedSet ??= widget.set;
    Map<String, Results> results =
        Map<String, Results>.from(curResultsBox.toMap());

    if (results.isEmpty && selectedSet != null) {
      for (String name in selectedSet!.exercises) {
        curResultsBox.put(
          name,
          Results(
            date: date,
            exerciseName: name,
            exerciseSet: selectedSet?.name,
          ),
        );
      }
    } else {
      modifiedResults = true;
    }
    resultsNames = List<String>.from(curResultsBox.keys);
  }

  @override
  void dispose() {
    super.dispose();
    if (!modifiedResults) {
      curResultsBox.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Exercise'),
        actions: [
          IconButton(
              onPressed: () {
                for (Results res in curResultsBox.values) {
                  if (res.reps!.any((e) => e > 0)) {
                    resultsBox.add(res);
                  }
                }
                curResultsBox.clear();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: widget.set == null
          ? const Center(
              child: Text(
              'Need to add an exercise set',
              style: TextStyle(fontSize: 24.0),
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<ExerciseSet>(
                            value: selectedSet,
                            hint: const Text('Select Set'),
                            items: exerciseSets.map((s) {
                              return DropdownMenuItem<ExerciseSet>(
                                value: s,
                                child: Text(s.name),
                              );
                            }).toList(),
                            onChanged: (ExerciseSet? val) => updateSet(val),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );
                          if (picked != null && picked != date) {
                            updateDate(picked);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: ThemeColors.kPurple,
                          child: Text(
                            formatter.format(date),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultsNames.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ExerciseLogCard(
                              key: Key(resultsNames[index] +
                                  date.toString() +
                                  selectedSet!.name),
                              exerciseName: resultsNames[index],
                              updateFromLast: !modifiedResults,
                              onAdd: () => logResult(resultsNames[index]),
                              onRemove: () => removeResult(resultsNames[index]),
                              onUpdated: () => modifiedResults = true,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewExerciseButton,
        backgroundColor: ThemeColors.kMint,
        child: const Icon(Icons.add),
      ),
    );
  }
}
