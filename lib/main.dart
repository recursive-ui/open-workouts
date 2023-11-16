import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_workouts/screens/add_edit_set.dart';
import 'package:open_workouts/screens/home.dart';
import 'package:open_workouts/screens/settings.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'models/exercises.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: ThemeColors.kPurple, // navigation bar color
    statusBarColor: ThemeColors.kPurple, // status bar color
  ));
  await Hive.initFlutter();
  Hive.registerAdapter<Exercise>(ExerciseAdapter());
  Hive.registerAdapter<ExerciseSet>(ExerciseSetAdapter());
  Hive.registerAdapter<Results>(ResultsAdapter());
  await Hive.openBox<Exercise>('exercises');
  await Hive.openBox<ExerciseSet>('sets');
  await Hive.openBox<Results>('results');
  await Hive.openBox('settings');
  await Hive.openBox<Results>('currentResults');
  runApp(const MyApp());
}

class ProgramProvider extends ChangeNotifier {
  Color mainColor = Colors.blue;
  void changeThemeColor(Color color) {
    mainColor = color;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Planner',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: ThemeColors.kPurple,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22.0,
            ),
          ),
          primaryColor: ThemeColors.kPurple,
          textTheme:
              GoogleFonts.sourceSansProTextTheme(Theme.of(context).textTheme)),
      initialRoute: '/',
      routes: {
        '/': ((context) => const HomePage()),
        '/add_set': ((context) => const AddSetScreen()),
        '/settings': ((context) => const SettingsPage())
      },
    );
  }
}
