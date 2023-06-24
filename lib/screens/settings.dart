import 'package:flutter/material.dart';
import 'package:open_workouts/models/loaders.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(
            onPressed: () => loadExercisesFromJson(
                jsonURL: 'assets/data/exercises.json', isLocal: true),
            child: const Text('Reset Exercises to Default'),
          ),
          TextButton(
            onPressed: () => clearExerciseBox(),
            child: const Text('Clear All Exercises'),
          ),
          TextButton(
            onPressed: () => exportToJson(),
            child: const Text('Export All Exercises'),
          ),
        ],
      ),
    );
  }
}
