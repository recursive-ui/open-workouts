import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_workouts/modal/add_exercise.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/rounded_button.dart';
import 'package:open_workouts/widgets/weekday_picker.dart';

class AddSetScreen extends StatefulWidget {
  final bool editMode;
  final int? setIndex;
  const AddSetScreen({Key? key, this.editMode = false, this.setIndex})
      : super(key: key);

  @override
  State<AddSetScreen> createState() => _AddSetScreenState();
}

class _AddSetScreenState extends State<AddSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  List<String> exercises = [];
  List<Exercise> allExercies = Hive.box<Exercise>('exercises').values.toList();
  String? exerciseToAdd;
  List<int> targetSets = [];
  List<bool> isCheckedDaysOfWeek = List.filled(7, false);

  void checkDayOfWeek(index) {
    setState(() {
      isCheckedDaysOfWeek[index] = !isCheckedDaysOfWeek[index];
    });
  }

  void addExerciseSet() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<int> daysOfWeek = [];
      for (int i = 0; i < 7; i++) {
        if (isCheckedDaysOfWeek[i]) {
          daysOfWeek.add(i);
        }
      }
      ExerciseSet newSet = ExerciseSet(
        name: nameController.text,
        daysOfWeek: daysOfWeek,
        exercises: exercises,
        targetSets: targetSets,
      );

      Box<ExerciseSet> setsBox = Hive.box<ExerciseSet>('sets');
      if (widget.editMode && widget.setIndex != null) {
        setsBox.putAt(widget.setIndex!, newSet);
      } else {
        setsBox.add(newSet);
      }

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.editMode && widget.setIndex != null) {
      final Box<ExerciseSet> box = Hive.box<ExerciseSet>('sets');
      final ExerciseSet? set = box.getAt(widget.setIndex!);
      if (set != null) {
        nameController.text = set.name;
        exercises = set.exercises;
        targetSets = set.targetSets;
        List<bool> tmpIsCheckedDaysOfWeek = List.filled(7, false);
        for (int weekday in set.daysOfWeek) {
          tmpIsCheckedDaysOfWeek[weekday] = true;
        }
        setState(() {
          isCheckedDaysOfWeek = tmpIsCheckedDaysOfWeek;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.editMode ? 'Edit Exercise Set' : 'Add Exercise Set')),
      body: Container(
        color: ThemeColors.kLightPurple,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: kInputDecoration.copyWith(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WeekdayPicker(
                    selectedWeekdays: isCheckedDaysOfWeek,
                    changeWeekday: checkDayOfWeek,
                  ),
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
                              exercises.add(exerciseToAdd!);
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
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: ThemeColors.kLightPurple,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                setState(() => exercises.removeAt(index)),
                            icon: Icon(MdiIcons.close),
                          ),
                          Flexible(
                            child: Text(
                              exercises.elementAt(index),
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
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedButton(
                        text: 'New Exercise',
                        backgroundColor: ThemeColors.kPink,
                        overlayColor: ThemeColors.kLightPink,
                        onPressed: () => showAddExercise(context),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedButton(
                        text: widget.editMode
                            ? 'Save Exercise Set'
                            : 'Add Exercise Set',
                        backgroundColor: ThemeColors.kMint,
                        overlayColor: ThemeColors.kLightMint,
                        onPressed: addExerciseSet,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
