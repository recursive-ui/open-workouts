import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/rounded_button.dart';
import 'package:open_workouts/widgets/add_program_card.dart';

class AddProgramScreen extends StatefulWidget {
  const AddProgramScreen({Key? key}) : super(key: key);

  @override
  State<AddProgramScreen> createState() => _AddProgramScreenState();
}

class _AddProgramScreenState extends State<AddProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  bool isCurrent = false;
  List<ExerciseSet> exerciseSets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Program')),
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
                  decoration: kInputDecoration.copyWith(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onChanged: (text) => setState(() => name = text),
                ),
              ),
              exerciseSets.isEmpty
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No Exercises',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ))
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: exerciseSets.length,
                        itemBuilder: (context, index) {
                          ExerciseSet set = exerciseSets[index];
                          return ProgramInputCard(
                            exerciseSet: set,
                            onPressed: () {
                              setState(() => exerciseSets.removeAt(index));
                            },
                          );
                        },
                      ),
                    ),
              Row(
                children: [
                  Checkbox(
                    value: isCurrent,
                    onChanged: (val) => setState(() => isCurrent = val!),
                  ),
                  const Text('Is Default Program'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  text: 'Add Exercise Set',
                  backgroundColor: ThemeColors.kPink,
                  overlayColor: ThemeColors.kLightPink,
                  onPressed: () {
                    setState(() => exerciseSets.add(ExerciseSet()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  text: 'Add Program',
                  backgroundColor: ThemeColors.kMint,
                  overlayColor: ThemeColors.kLightMint,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Program newProgram = Program(
                        name: name,
                        isCurrent: isCurrent,
                        exerciseSets: exerciseSets,
                      );

                      Box<Program> programsBox = Hive.box<Program>('programs');
                      programsBox.add(newProgram);
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
