import 'package:flutter/material.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/models/loaders.dart';
import 'package:open_workouts/screens/logging.dart';
import 'package:open_workouts/widgets/exercise_set_card.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExerciseSet? nextExerciseSet = getNextExerciseSet();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Workout',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16.0),
            nextExerciseSet != null
                ? ExerciseSetCard(
                    set: nextExerciseSet,
                    showIcon: false,
                    onCardPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoggingPage(
                          set: nextExerciseSet,
                        ),
                      ),
                    ),
                  )
                : const Text('No exercises')
          ],
        ),
      ),
    );
  }
}
