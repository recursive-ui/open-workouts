import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/screens/add_edit_set.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/exercise_set_card.dart';

class ExerciseSetsPage extends StatelessWidget {
  const ExerciseSetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.kLightPurple,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ExerciseSet>('sets').listenable(),
        builder: (context, Box<ExerciseSet> box, child) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                "No Exercise Sets",
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              ExerciseSet? curSet = box.getAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: ExerciseSetCard(
                  set: curSet!,
                  onCardPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddSetScreen(editMode: true, setIndex: index),
                    ),
                  ),
                  onIconPressed: () => box.delete(curSet.key),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_set');
        },
        backgroundColor: ThemeColors.kMint,
        child: const Icon(Icons.add),
      ),
    );
  }
}
