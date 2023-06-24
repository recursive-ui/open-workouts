import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
// import 'package:number_selection/number_selection.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const daysOfWeek = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];

class ProgramInputCard extends StatefulWidget {
  final ExerciseSet exerciseSet;
  final void Function()? onPressed;
  const ProgramInputCard({
    Key? key,
    required this.exerciseSet,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ProgramInputCard> createState() => _ProgramInputCardState();
}

class _ProgramInputCardState extends State<ProgramInputCard> {
  List<Exercise> exercises = Hive.box<Exercise>('exercises').values.toList();
  String? exerciseToAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        initialValue: widget.exerciseSet.name,
                        onChanged: (text) =>
                            setState(() => widget.exerciseSet.name = text),
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onPressed,
                    icon: Icon(MdiIcons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: DropdownButtonFormField<int>(
                hint: const Text('Choose a day of the week'),
                value: widget.exerciseSet.dayOfWeek,
                items: daysOfWeek.map((d) {
                  return DropdownMenuItem<int>(
                    value: daysOfWeek.indexOf(d),
                    child: Text(d),
                  );
                }).toList(),
                onChanged: (day) => setState(() {
                  widget.exerciseSet.dayOfWeek = day ?? 0;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          isDense: false,
                          hint: const Text('Add an exercise'),
                          items: exercises.map((e) {
                            return DropdownMenuItem<String>(
                              value: e.name,
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
                          onChanged: (value) =>
                              setState(() => exerciseToAdd = value)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: ThemeColors.kLightPink,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.exerciseSet
                                .addExercise(name: exerciseToAdd!);
                          });
                        },
                        icon: Icon(
                          MdiIcons.plus,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.exerciseSet.exercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: ThemeColors.kLightPurple,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(
                              () => widget.exerciseSet.removeAt(index)),
                          icon: Icon(MdiIcons.close),
                        ),
                        Flexible(
                          child: Text(
                            widget.exerciseSet.exercises.elementAt(index),
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
