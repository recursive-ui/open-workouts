import 'package:flutter/material.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_workouts/screens/edit_program.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final int programIndex;
  final void Function()? onPressed;
  const ProgramCard({
    Key? key,
    required this.program,
    required this.programIndex,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProgramScreen(
                programIndex: programIndex,
              ),
            )),
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
                      program.name,
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
              program.exerciseSets == null
                  ? const Center(child: Text('No exercises'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: program.exerciseSets!.length,
                      itemBuilder: (context, index) {
                        ExerciseSet set = program.exerciseSets![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          child: Table(
                            children: [
                              TableRow(children: [
                                Text(set.getWeekdayName()),
                                Text(set.name),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: set.exercises
                                      .map((e) => Text(e))
                                      .toList(),
                                ),
                              ]),
                            ],
                          ),
                        );
                      },
                    ),
              Row(children: [
                Checkbox(value: program.isCurrent, onChanged: (v) {}),
                const Text('Is current program'),
              ]),
              const SizedBox(height: 12.0)
            ],
          ),
        ),
      ),
    );
  }
}
