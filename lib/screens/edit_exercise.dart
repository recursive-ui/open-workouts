import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/dropdown_field.dart';
import 'package:open_workouts/widgets/rounded_button.dart';

const List<String> muscles = [
  'Abs',
  'Back',
  'Biceps',
  'Calves',
  'Chest',
  'Glutes',
  'Hamstrings & Glutes',
  'Quads & Glutes',
  'Shoulders',
  'Triceps'
];

const List<String> exerciseTypes = [
  'Close-grip Press',
  'Core',
  'Curl',
  'Facepull variation',
  'Horizontal Press',
  'Horizontal pull',
  'Horizontal Push',
  'Incline Press',
  'Isolation',
  'Lift',
  'Quad compound',
  'Raises',
  'Side delt isolation',
  'Vertical press',
  'Vertical pull',
];

class EditExerciseScreen extends StatefulWidget {
  final int exerciseIndex;
  const EditExerciseScreen({
    Key? key,
    required this.exerciseIndex,
  }) : super(key: key);

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? muscle;
  String? exerciseType;
  String? level;
  String? imageURL;
  String? notes;

  final Box<Exercise> box = Hive.box<Exercise>('exercises');

  @override
  Widget build(BuildContext context) {
    final Exercise? exercise = box.getAt(widget.exerciseIndex);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: ThemeColors.kLightPurple,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: exercise != null ? exercise.name : '',
                  decoration: kInputDecoration.copyWith(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (text) => name = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownField(
                  items: muscles,
                  initialValue: exercise != null ? exercise.muscle ?? '' : '',
                  decoration: kInputDecoration.copyWith(labelText: 'Muscle'),
                  onSaved: (text) => muscle = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownField(
                  items: exerciseTypes,
                  initialValue: exercise != null ? exercise.type ?? '' : '',
                  decoration: kInputDecoration.copyWith(labelText: 'Type'),
                  onSaved: (text) => exerciseType = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: exercise != null ? exercise.level ?? '' : '',
                  decoration:
                      kInputDecoration.copyWith(labelText: 'Difficulty'),
                  onSaved: (text) => level = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: null,
                  initialValue: exercise != null ? exercise.notes ?? '' : '',
                  decoration: kInputDecoration.copyWith(labelText: 'Notes'),
                  onSaved: (text) => notes = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue:
                        exercise != null ? exercise.imageUrl ?? '' : '',
                    decoration: kInputDecoration.copyWith(labelText: 'Image'),
                    onSaved: (text) => imageURL = text,
                    validator: (value) {
                      if (value != null && value != '') {
                        if (Uri.parse(value).isAbsolute == false) {
                          return 'Please enter a valid image url';
                        }
                      }
                      return null;
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                      text: 'Cancel',
                      fixedSize: const Size(120, 50),
                      backgroundColor: ThemeColors.kOrange,
                      overlayColor: ThemeColors.kLightOrange,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                      text: 'Save',
                      fixedSize: const Size(120, 50),
                      backgroundColor: ThemeColors.kMint,
                      overlayColor: ThemeColors.kLightMint,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Exercise newExercise = Exercise(
                              name: name!,
                              muscle: muscle,
                              type: exerciseType,
                              level: level,
                              notes: notes,
                              imageUrl: imageURL);

                          Box<Exercise> exerciseBox =
                              Hive.box<Exercise>('exercises');
                          exerciseBox.putAt(widget.exerciseIndex, newExercise);
                          Navigator.pop(context);
                        }
                      },
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
