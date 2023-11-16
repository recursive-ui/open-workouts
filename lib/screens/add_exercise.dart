import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/dropdown_field.dart';
import 'package:open_workouts/widgets/rounded_button.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? muscle;
  String? exerciseType;
  String? level;
  String? imageURL;
  String? notes;

  @override
  Widget build(BuildContext context) {
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
                  decoration: kInputDecoration.copyWith(labelText: 'Muscle'),
                  onSaved: (text) => muscle = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownField(
                  items: exerciseTypes,
                  decoration: kInputDecoration.copyWith(labelText: 'Type'),
                  onSaved: (text) => exerciseType = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: kInputDecoration.copyWith(labelText: 'Notes'),
                  onSaved: (text) => notes = text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  text: 'Add',
                  backgroundColor: ThemeColors.kMint,
                  overlayColor: ThemeColors.kLightMint,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Exercise newExercise = Exercise(
                          name: name!,
                          muscle: muscle,
                          type: exerciseType,
                          notes: notes,
                          imageUrl: imageURL);

                      Box<Exercise> exerciseBox =
                          Hive.box<Exercise>('exercises');
                      exerciseBox.add(newExercise);
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
