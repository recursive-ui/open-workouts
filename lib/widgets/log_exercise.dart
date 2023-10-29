import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:number_selection/number_selection.dart';
import 'package:open_workouts/widgets/dropdown_field.dart';

class ExerciseLogCard extends StatefulWidget {
  final Exercise exercise;
  final Results result;
  final void Function()? onRemove;
  final void Function()? onAdd;
  const ExerciseLogCard({
    Key? key,
    required this.exercise,
    required this.result,
    this.onRemove,
    this.onAdd,
  }) : super(key: key);

  @override
  State<ExerciseLogCard> createState() => _ExerciseLogCardState();
}

class _ExerciseLogCardState extends State<ExerciseLogCard> {
  final Box<Results> resultsBox = Hive.box<Results>('results');

  Widget getExerciseImage() {
    if (widget.exercise.imageUrl != null &&
        widget.exercise.imageUrl != '' &&
        widget.exercise.imageUrl!.endsWith('.gif')) {
      return Image(
          image: CachedNetworkImageProvider(widget.exercise.imageUrl!));
    }
    return const Padding(
      padding: EdgeInsets.only(
        top: 0,
        bottom: 4.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Text('No Image.'),
    );
  }

  @override
  void initState() {
    super.initState();

    List<Results> allResults = resultsBox.values.toList();
    List<Results> latestResults = allResults
        .where((r) => r.exerciseName == widget.result.exerciseName)
        .toList();

    if (latestResults.isNotEmpty) {
      latestResults.sort((a, b) => a.date.compareTo(b.date));
      Results latestResult = latestResults[latestResults.length - 1];
      widget.result.reps = latestResult.reps;
      widget.result.measure = latestResult.measure;
      widget.result.units = latestResult.units;
      widget.result.notes = latestResult.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 0.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add),
                ),
                Text(
                  widget.exercise.name,
                  style: const TextStyle(
                    color: ThemeColors.kPurple,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getExerciseImage(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Number of Sets'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 75.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: NumberSelection(
                      theme: NumberSelectionTheme(
                          draggableCircleColor: ThemeColors.kMint,
                          iconsColor: Colors.white,
                          numberColor: Colors.white,
                          backgroundColor: ThemeColors.kPurple,
                          outOfConstraintsColor: Colors.deepOrange),
                      initialValue: widget.result.sets,
                      minValue: 0,
                      maxValue: 20,
                      direction: Axis.horizontal,
                      withSpring: false,
                      onChanged: (int value) =>
                          setState(() => widget.result.sets = value),
                      enableOnOutOfConstraintsAnimation: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List<Widget>.generate(widget.result.sets, (index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NumberSelection(
                    theme: NumberSelectionTheme(
                        draggableCircleColor: ThemeColors.kMint,
                        iconsColor: Colors.white,
                        numberColor: Colors.white,
                        backgroundColor: ThemeColors.kPurple,
                        outOfConstraintsColor: Colors.deepOrange),
                    initialValue: widget.result.reps![index],
                    minValue: 0,
                    maxValue: 100,
                    direction: Axis.vertical,
                    withSpring: false,
                    onChanged: (int value) =>
                        widget.result.reps![index] = value,
                    enableOnOutOfConstraintsAnimation: true,
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.result.measure == null
                          ? ''
                          : widget.result.measure.toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Measurement e.g. weight'),
                      onChanged: (measure) {
                        if (measure != '') {
                          widget.result.measure = double.parse(measure);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownField(
                      initialValue: widget.result.units,
                      items: commonUnits,
                      decoration: const InputDecoration(labelText: 'Units'),
                      onChanged: (val) => widget.result.units = val,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: widget.result.notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              onChanged: (notes) {
                if (notes != '') {
                  widget.result.notes = notes;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
