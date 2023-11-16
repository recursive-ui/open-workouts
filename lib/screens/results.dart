import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_workouts/models/exercises.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:open_workouts/utilities/maths.dart';

const List<Widget> chartTypes = <Widget>[
  Text('% Improvement'),
  Text('# Reps'),
  Text('Measure')
];

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Results mostRecentResult;
  late String selectedSet;
  late String selectedExercise;
  final DateFormat formatter = DateFormat('dd MMM');
  final List<ExerciseSet> sets = Hive.box<ExerciseSet>('sets').values.toList();
  List<Exercise> exercises = Hive.box<Exercise>('exercises').values.toList();
  Box<Results> resultsBox = Hive.box<Results>('results');
  late List<Results> results;
  late List<Results> allResults;
  final List<bool> _selectedChartType = <bool>[true, false, false];

  List<DropdownMenuItem<String>> getExerciseSets() {
    return sets.map<DropdownMenuItem<String>>((ExerciseSet value) {
      return DropdownMenuItem<String>(
        value: value.name,
        child: Text(value.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> getExercises() {
    return exercises.map<DropdownMenuItem<String>>((Exercise value) {
      return DropdownMenuItem<String>(
        value: value.name,
        child: Text(value.name),
      );
    }).toList();
  }

  List<FlSpot>? getExerciseDataArray() {
    List<Results> setResults =
        results.where((e) => e.exerciseName == selectedExercise).toList();
    if (setResults.length < 2) {
      return null;
    }
    List<DateTime> resultDates = setResults.map((e) => e.date).toSet().toList();
    resultDates.sort();
    List<FlSpot> spots = [];

    if (_selectedChartType[0] == true) {
      spots.add(FlSpot(resultDates[0].microsecondsSinceEpoch.toDouble(), 0));

      for (int i = 1; i < resultDates.length; i++) {
        Results curResult =
            setResults.firstWhere((e) => e.date == resultDates[i]);
        Results? prevResult =
            setResults.firstWhere((e) => e.date == resultDates[i - 1]);
        spots.add(FlSpot(resultDates[i].microsecondsSinceEpoch.toDouble(),
            curResult.percentImprovement(prevResult) * 100 + spots[i - 1].y));
      }
    } else if (_selectedChartType[1] == true) {
      for (int i = 0; i < resultDates.length; i++) {
        Results curResult =
            setResults.firstWhere((e) => e.date == resultDates[i]);
        spots.add(FlSpot(resultDates[i].microsecondsSinceEpoch.toDouble(),
            mean(curResult.reps ?? [0])));
      }
    } else {
      for (int i = 0; i < resultDates.length; i++) {
        Results curResult =
            setResults.firstWhere((e) => e.date == resultDates[i]);
        spots.add(FlSpot(resultDates[i].microsecondsSinceEpoch.toDouble(),
            curResult.measure ?? 0));
      }
    }

    return spots;
  }

  List<FlSpot>? getSetDataArray() {
    List<Results> setResults =
        results.where((e) => e.exerciseSet == selectedSet).toList();
    if (setResults.length < 2) {
      return null;
    }
    List<DateTime> resultDates = setResults.map((e) => e.date).toSet().toList();
    resultDates.sort();
    List<FlSpot> spots = [
      FlSpot(resultDates[0].microsecondsSinceEpoch.toDouble(), 0)
    ];
    for (int i = 1; i < resultDates.length; i++) {
      List<String> exercises = results
          .where((e) => e.date == resultDates[i])
          .map((e) => e.exerciseName)
          .toList();
      List<double> values = [];
      for (String exer in exercises) {
        Results? curResult = setResults.firstWhereOrNull(
            (e) => e.date == resultDates[i] && e.exerciseName == exer);
        Results? prevResult = setResults.firstWhereOrNull(
            (e) => e.date == resultDates[i - 1] && e.exerciseName == exer);
        if (prevResult != null && curResult != null) {
          values.add(curResult.percentImprovement(prevResult));
        }
      }
      if (values.length > 1) {
        spots.add(FlSpot(resultDates[i].microsecondsSinceEpoch.toDouble(),
            mean(values) * 100 + spots[i - 1].y));
      }
    }
    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
    return SideTitleWidget(
      angle: -45,
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        formatter.format(date),
        style: const TextStyle(
          fontSize: 10,
          color: ThemeColors.kLightPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getExerciseSetChart() {
    if (selectedSet == 'None') {
      return const Center(child: Text('Not enough data yet.'));
    }
    List<FlSpot>? chartData = getSetDataArray();
    if (chartData == null) {
      return const Center(child: Text('Not enough data yet.'));
    }
    return getFormattedChart(chartData);
  }

  Widget getExerciseChart() {
    List<FlSpot>? chartData = getExerciseDataArray();
    if (chartData == null) {
      return const Center(child: Text('Not enough data yet.'));
    }
    return getFormattedChart(chartData);
  }

  String getChartTitle() {
    if (_selectedChartType[0] == true) {
      return '% Improvement';
    } else if (_selectedChartType[1] == true) {
      return '# Reps';
    }
    return 'Measure';
  }

  Widget getFormattedChart(List<FlSpot> chartData) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              getChartTitle(),
              style: const TextStyle(
                  fontSize: 16, color: ThemeColors.kLightPurple),
            ),
            sideTitles: SideTitles(
              reservedSize: 32,
              showTitles: true,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  meta.formattedValue,
                  style: const TextStyle(color: ThemeColors.kLightPurple),
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
                color: ThemeColors.kPurple.withOpacity(0.2), width: 4),
            left: const BorderSide(color: Colors.transparent),
            right: const BorderSide(color: Colors.transparent),
            top: const BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: false,
            color: ThemeColors.kPurple,
            barWidth: 4,
            spots: chartData,
            dotData: FlDotData(show: chartData.length == 1),
          )
        ],
      ),
    );
  }

  String getResultSubtitle(Results res) {
    String reps = res.reps?.join(' - ') ?? '';
    String measure = res.measure == null ? '' : res.measure.toString();
    String units = res.units ?? '';
    return '$reps   $measure$units';
  }

  void deleteResult(int key) {
    resultsBox.delete(key);
    setState(() {
      allResults = resultsBox.values.toList();
      allResults.sort((a, b) => b.date.compareTo(a.date));
      results = allResults.where((e) => e.reps?.isNotEmpty ?? false).toList();
      List<String> uniqueExercises =
          results.map((e) => e.exerciseName).toSet().toList();
      exercises =
          exercises.where((e) => uniqueExercises.contains(e.name)).toList();
      mostRecentResult = results.firstWhere((e) => e.exerciseSet != null,
          orElse: () => Results(date: DateTime.now(), exerciseName: 'None'));
      selectedSet = mostRecentResult.exerciseSet ?? 'None';
      selectedExercise = results.isEmpty ? '' : results.first.exerciseName;
    });
  }

  @override
  void initState() {
    super.initState();
    allResults = resultsBox.values.toList();
    allResults.sort((a, b) => b.date.compareTo(a.date));
    results = allResults.where((e) => e.reps?.isNotEmpty ?? false).toList();
    List<String> uniqueExercises =
        results.map((e) => e.exerciseName).toSet().toList();
    exercises =
        exercises.where((e) => uniqueExercises.contains(e.name)).toList();
    mostRecentResult = results.firstWhere((e) => e.exerciseSet != null,
        orElse: () => Results(date: DateTime.now(), exerciseName: 'None'));
    selectedSet = mostRecentResult.exerciseSet ?? 'None';
    selectedExercise = results.isEmpty ? '' : results.first.exerciseName;
  }

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty || exercises.isEmpty) {
      return const Center(child: Text('No results yet.'));
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Select Exercise Set'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: selectedSet,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedSet = value!;
                    });
                  },
                  items: getExerciseSets(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            child: getExerciseSetChart(),
          ),
          const SizedBox(height: 32),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selectedChartType.length; i++) {
                  _selectedChartType[i] = i == index;
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: ThemeColors.kPurple,
            selectedColor: Colors.white,
            fillColor: ThemeColors.kLightPurple,
            color: ThemeColors.kPurple,
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: _selectedChartType,
            children: chartTypes,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Select Exercise'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: selectedExercise,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedExercise = value!;
                    });
                  },
                  items: getExercises(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            child: getExerciseChart(),
          ),
          const SizedBox(height: 16),
          const Text(
            'All Results',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: allResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: Text(formatter.format(allResults[index].date)),
                  title: Text(allResults[index].exerciseName),
                  subtitle: Text(getResultSubtitle(allResults[index])),
                  trailing: IconButton(
                    onPressed: () => deleteResult(allResults[index].key),
                    icon: Icon(MdiIcons.close),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
