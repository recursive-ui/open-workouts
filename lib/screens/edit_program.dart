import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/rounded_button.dart';
import 'package:open_workouts/widgets/add_program_card.dart';

class EditProgramScreen extends StatefulWidget {
  final int programIndex;
  const EditProgramScreen({Key? key, required this.programIndex})
      : super(key: key);

  @override
  State<EditProgramScreen> createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final Box<Program> box = Hive.box<Program>('programs');

  @override
  Widget build(BuildContext context) {
    final Program? program = box.getAt(widget.programIndex);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Program')),
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
                  initialValue: program!.name,
                  decoration: kInputDecoration.copyWith(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onChanged: (text) => setState(() => program.name = text),
                ),
              ),
              program.exerciseSets!.isEmpty
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
                        itemCount: program.exerciseSets!.length,
                        itemBuilder: (context, index) {
                          ExerciseSet set = program.exerciseSets![index];
                          return ProgramInputCard(
                            exerciseSet: set,
                            onPressed: () {
                              setState(
                                  () => program.exerciseSets!.removeAt(index));
                            },
                          );
                        },
                      ),
                    ),
              Row(
                children: [
                  Checkbox(
                    value: program.isCurrent,
                    onChanged: (val) => setState(() => program.isCurrent = val),
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
                    setState(() => program.exerciseSets!.add(ExerciseSet()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoundedButton(
                  text: 'Save Program',
                  backgroundColor: ThemeColors.kMint,
                  overlayColor: ThemeColors.kLightMint,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Program newProgram = Program(
                        name: program.name,
                        isCurrent: program.isCurrent,
                        exerciseSets: program.exerciseSets,
                      );

                      Box<Program> programsBox = Hive.box<Program>('programs');
                      programsBox.putAt(widget.programIndex, newProgram);
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
