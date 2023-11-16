import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:number_selection/number_selection.dart';
import 'package:open_workouts/widgets/dropdown_field.dart';

class ExerciseLogCard extends StatefulWidget {
  final String exerciseName;
  final bool updateFromLast;
  final void Function()? onRemove;
  final void Function()? onAdd;
  final void Function()? onUpdated;
  const ExerciseLogCard({
    Key? key,
    required this.exerciseName,
    this.updateFromLast = false,
    this.onRemove,
    this.onAdd,
    this.onUpdated,
  }) : super(key: key);

  @override
  State<ExerciseLogCard> createState() => _ExerciseLogCardState();
}

class _ExerciseLogCardState extends State<ExerciseLogCard> {
  final Box<Results> resultsBox = Hive.box<Results>('results');
  final Box<Results> curResultsBox = Hive.box<Results>('currentResults');
  late Exercise? exercise;
  late Results? result;

  Widget getExerciseImage() {
    if (exercise != null &&
        exercise?.imageUrl != null &&
        exercise?.imageUrl != '') {
      return Image(image: CachedNetworkImageProvider(exercise!.imageUrl!));
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

  void updateUnits(String? val) {
    if (val != '') {
      result?.units = val;
      if (widget.onUpdated != null) {
        widget.onUpdated!();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    exercise = Hive.box<Exercise>('exercises').get(widget.exerciseName);
    result = curResultsBox.get(widget.exerciseName);

    if (result != null && widget.updateFromLast) {
      List<Results> latestResults = resultsBox.values
          .where((r) => r.exerciseName == result?.exerciseName)
          .toList();

      if (latestResults.isNotEmpty) {
        latestResults.sort((a, b) => a.date.compareTo(b.date));
        Results latestResult = latestResults[latestResults.length - 1];
        result?.reps = latestResult.reps == null
            ? null
            : List<int>.from(latestResult.reps!);
        result?.measure = latestResult.measure;
        result?.units = latestResult.units;
        result?.notes = latestResult.notes;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Container();
    }
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
                Flexible(
                  child: Text(
                    exercise?.name ?? '',
                    style: const TextStyle(
                      color: ThemeColors.kPurple,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                    ),
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
                      initialValue: result?.sets,
                      minValue: 0,
                      maxValue: 20,
                      direction: Axis.horizontal,
                      withSpring: false,
                      onChanged: (int value) {
                        if (widget.onUpdated != null) {
                          setState(() => result?.sets = value);
                          widget.onUpdated!();
                        }
                      },
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
              children: List<Widget>.generate(result!.sets, (index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NumberSelection(
                    theme: NumberSelectionTheme(
                        draggableCircleColor: ThemeColors.kMint,
                        iconsColor: Colors.white,
                        numberColor: Colors.white,
                        backgroundColor: ThemeColors.kPurple,
                        outOfConstraintsColor: Colors.deepOrange),
                    initialValue: result?.reps![index],
                    minValue: 0,
                    maxValue: 100,
                    direction: Axis.vertical,
                    withSpring: false,
                    onChanged: (int value) {
                      result?.reps![index] = value;
                      if (widget.onUpdated != null) {
                        widget.onUpdated!();
                      }
                    },
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
                      initialValue: result?.measure == null
                          ? ''
                          : result?.measure.toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Measurement e.g. weight'),
                      onChanged: (measure) {
                        if (measure != '') {
                          result?.measure = double.parse(measure);
                          if (widget.onUpdated != null) {
                            widget.onUpdated!();
                          }
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
                      initialValue: result?.units,
                      items: commonUnits,
                      decoration: const InputDecoration(labelText: 'Units'),
                      onChanged: updateUnits,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: result?.notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              onChanged: (notes) {
                if (notes != '') {
                  result?.notes = notes;
                  if (widget.onUpdated != null) {
                    widget.onUpdated!();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
