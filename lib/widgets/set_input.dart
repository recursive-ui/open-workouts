import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SetInput extends StatefulWidget {
  final List<String> exercises;
  final List<int> daysOfWeek;
  final void Function()? onPressed;
  const SetInput({
    Key? key,
    required this.exercises,
    required this.daysOfWeek,
    this.onPressed,
  }) : super(key: key);

  @override
  State<SetInput> createState() => _SetInputState();
}

class _SetInputState extends State<SetInput> {
  List<Exercise> allExercies = Hive.box<Exercise>('exercises').values.toList();
  String? exerciseToAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
                      items: allExercies.map((e) {
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
                        widget.exercises.add(exerciseToAdd!);
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
      ],
    );
  }
}
