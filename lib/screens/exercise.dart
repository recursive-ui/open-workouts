import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/screens/add_exercise.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/exercise_card.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Exercise>('exercises').listenable(),
        builder: (context, Box<Exercise> box, child) {
          Map<dynamic, Exercise> boxMap = box.toMap();
          boxMap.removeWhere((key, value) => value.disabled == true);

          if (boxMap.isEmpty) {
            return const Center(
              child: Text(
                "No exercises",
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ListView.builder(
              itemCount: boxMap.values.length,
              itemBuilder: (context, index) {
                Exercise? curExer = boxMap.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: ExerciseCard(
                    curExer: curExer,
                    exerciseIndex: index,
                    onPressed: () {
                      curExer.disabled = true;
                      box.put(boxMap.keys.elementAt(index), curExer);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(50.0))),
            builder: (context) => SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const AddExerciseScreen(),
            )),
          );
        },
        backgroundColor: ThemeColors.kMint,
        child: const Icon(Icons.add),
      ),
    );
  }
}
