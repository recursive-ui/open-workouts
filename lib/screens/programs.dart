import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/widgets/program_card.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.kLightPurple,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Program>('programs').listenable(),
        builder: (context, Box<Program> box, child) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text(
                "No programs",
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Program? curProgram = box.getAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: ProgramCard(
                  program: curProgram!,
                  programIndex: index,
                  onPressed: () => box.delete(curProgram.key),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_program');
        },
        backgroundColor: ThemeColors.kMint,
        child: const Icon(Icons.add),
      ),
    );
  }
}
