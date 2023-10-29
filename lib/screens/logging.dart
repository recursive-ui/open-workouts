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
  final List<Exercise> exercises =
      Hive.box<Exercise>('exercises').values.toList();
  final Box<Results> resultsBox = Hive.box<Results>('results');
  final DateFormat formatter = DateFormat('dd-MM');
  ExerciseSet? selectedSet;
  Exercise? selectedExercise;
  List<Exercise> exerciseList = [];
  List<Results> results = [];
  late DateTime now;
  late DateTime date = DateTime.now();

  void updateSet(newSet) {
    setState(() {
      selectedSet = newSet;
      if (selectedSet != null) {
        exerciseList = exercises
            .where((e) => selectedSet!.exercises.contains(e.name))
            .toList();
        results = exerciseList
            .map((e) => Results(
                  date: date,
                  exerciseName: e.name,
                  exerciseSet: selectedSet?.name,
                ))
            .toList();
        for (int i = 0; i < selectedSet!.targetSets.length; i++) {
          results[i].sets = selectedSet!.targetSets[i];
        }
      } else {
        exerciseList = [];
        results = [];
      }
    });
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
      setState(() {
        exerciseList.add(selectedExercise!);
        Results newResult = Results(
          date: date,
          exerciseName: selectedExercise!.name,
          exerciseSet: selectedSet?.name,
        );
        newResult.sets = 3;
        results.add(newResult);
      });
      Navigator.pop(context);
    }
  }

  void logResult(int index) {
    setState(() {
      resultsBox.add(results[index]);
      exerciseList.removeAt(index);
      results.removeAt(index);
    });
  }

  void removeResult(int index) {
    setState(() {
      exerciseList.removeAt(index);
      results.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);

    selectedSet = widget.set;

    if (selectedSet != null) {
      exerciseList = exercises
          .where((e) => selectedSet!.exercises.contains(e.name))
          .toList();
      results = exerciseList
          .map((e) => Results(date: date, exerciseName: e.name))
          .toList();
      for (int i = 0; i < selectedSet!.targetSets.length; i++) {
        results[i].sets = selectedSet!.targetSets[i];
      }
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
                for (Results res in results) {
                  if (res.reps!.any((e) => e > 0)) {
                    resultsBox.add(res);
                  }
                }
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
                            onChanged: (val) => updateSet(val),
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
                            setState(() => date = picked);
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
                      child: exerciseList.isEmpty
                          ? const Text('No Exercises in Set')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: exerciseList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ExerciseLogCard(
                                    exercise: exerciseList[index],
                                    result: results[index],
                                    onAdd: () => logResult(index),
                                    onRemove: () => removeResult(index),
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
