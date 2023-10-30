import 'package:flutter/material.dart';
import 'package:open_workouts/screens/exercise.dart';
import 'package:open_workouts/screens/landing.dart';
import 'package:open_workouts/screens/results.dart';
import 'package:open_workouts/screens/sets.dart';
import 'package:open_workouts/screens/settings.dart';
import 'package:open_workouts/utilities/constants.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 2,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ThemeColors.kOffWhite,
          child: TabBarView(
            physics:
                const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
            controller: _tabController,
            children: const <Widget>[
              ExercisePage(),
              ExerciseSetsPage(),
              Landingpage(),
              ResultsScreen(),
              SettingsPage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: 'Home',
        labels: const ['Exercises', 'Sets', 'Home', 'Results', 'Settings'],
        icons: [
          MdiIcons.dumbbell,
          MdiIcons.calendarText,
          MdiIcons.home,
          MdiIcons.chartLine,
          MdiIcons.cog
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: ThemeColors.kPurple,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: ThemeColors.kLightPurple,
        tabIconSize: 30.0,
        tabIconSelectedSize: 32.0,
        tabSelectedColor: ThemeColors.kPurple,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController.index = value;
          });
        },
      ),
    );
  }
}
