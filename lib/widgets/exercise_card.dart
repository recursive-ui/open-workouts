import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/screens/edit_exercise.dart';
import 'package:open_workouts/utilities/constants.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    Key? key,
    required this.curExer,
    required this.exerciseIndex,
    this.onPressed,
  }) : super(key: key);

  final int exerciseIndex;
  final Exercise curExer;
  final void Function()? onPressed;

  String getSubtext(String? type, String? level) {
    if (type == null && level == null) {
      return '';
    } else if (type != null && level != null) {
      return '$type - $level';
    } else if (type == null) {
      return level!;
    } else {
      return type;
    }
  }

  BoxDecoration getCardBackground() {
    if (curExer.imageUrl != null &&
        curExer.imageUrl != '' &&
        curExer.imageUrl!.endsWith('.gif')) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        image: DecorationImage(
          image: CachedNetworkImageProvider(curExer.imageUrl!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.2), BlendMode.dstATop),
        ),
      );
    }
    return BoxDecoration(borderRadius: BorderRadius.circular(15));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: getCardBackground(),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(50.0))),
              builder: (context) => SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: EditExerciseScreen(exerciseIndex: exerciseIndex),
              )),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                        child: Text(
                          curExer.muscle ?? '',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
                        child: Text(
                          curExer.name,
                          style: const TextStyle(
                            color: ThemeColors.kPurple,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
                        child: Text(
                          getSubtext(curExer.type, curExer.level),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                            color: ThemeColors.kLightPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: onPressed, icon: Icon(MdiIcons.close)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleExerciseCard extends StatelessWidget {
  const SimpleExerciseCard({
    Key? key,
    required this.curExer,
  }) : super(key: key);

  final Exercise curExer;

  String getSubtext(String? type, String? level) {
    if (type == null && level == null) {
      return '';
    } else if (type != null && level != null) {
      return '$type - $level';
    } else if (type == null) {
      return level!;
    } else {
      return type;
    }
  }

  BoxDecoration getCardBackground() {
    if (curExer.imageUrl != null &&
        curExer.imageUrl != '' &&
        curExer.imageUrl!.endsWith('.gif')) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        image: DecorationImage(
          image: CachedNetworkImageProvider(curExer.imageUrl!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.2), BlendMode.dstATop),
        ),
      );
    }
    return BoxDecoration(borderRadius: BorderRadius.circular(15));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: getCardBackground(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0, bottom: 0.0),
                      child: Text(
                        curExer.muscle ?? '',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
                      child: Text(
                        curExer.name,
                        style: const TextStyle(
                          color: ThemeColors.kPurple,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 8.0, right: 8.0, bottom: 0.0),
                      child: Text(
                        getSubtext(curExer.type, curExer.level),
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic,
                          color: ThemeColors.kLightPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
