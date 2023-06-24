import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_workouts/widgets/exercise_card.dart';

class ExerciseSetCard extends StatelessWidget {
  final ExerciseSet set;
  final void Function()? onPressed;
  const ExerciseSetCard({
    Key? key,
    required this.set,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Exercise> exerciseBox = Hive.box<Exercise>('exercises');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      set.name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: onPressed,
                      icon: Icon(MdiIcons.close),
                    ),
                  ],
                ),
              ),
              set.exercises.isEmpty
                  ? const Center(child: Text('No exercises'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: set.exercises.length,
                      itemBuilder: (context, index) {
                        List<Exercise> matchingExer = exerciseBox.values
                            .where((e) => e.name == set.exercises[index])
                            .toList();
                        Exercise curExercise = matchingExer[0];
                        return SimpleExerciseCard(curExer: curExercise);
                      },
                    ),
              const SizedBox(height: 12.0)
            ],
          ),
        ),
      ),
    );
  }
}
