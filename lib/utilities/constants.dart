import 'package:flutter/material.dart';

const commonUnits = ['kg', 'g', 'min', 's'];

const List<String> muscles = [
  'Abs',
  'Back',
  'Biceps',
  'Calves',
  'Chest',
  'Glutes',
  'Hamstrings & Glutes',
  'Quads & Glutes',
  'Shoulders',
  'Triceps'
];

const List<String> exerciseTypes = [
  'Close-grip Press',
  'Core',
  'Curl',
  'Facepull variation',
  'Horizontal Press',
  'Horizontal pull',
  'Horizontal Push',
  'Incline Press',
  'Isolation',
  'Lift',
  'Quad compound',
  'Raises',
  'Side delt isolation',
  'Vertical press',
  'Vertical pull',
];

class ThemeColors {
  static const Color kOffWhite = Color(0xFFF5F5F5);
  static const Color kPink = Color(0xFFFC5185);
  static const Color kLightPink = Color(0xFFfd79a8);
  static const Color kPurple = Color(0xFF6c5ce7);
  static const Color kLightPurple = Color(0xFFa29bfe);
  static const Color kLightYellow = Color(0xFFffeaa7);
  static const Color kMint = Color(0xFF00b894);
  static const Color kLightMint = Color(0xFF55efc4);
  static const Color kOrange = Color(0xFFe17055);
  static const Color kLightOrange = Color(0xFFfab1a0);
}

const InputDecoration kInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ThemeColors.kOffWhite, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ThemeColors.kPurple, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
  labelStyle: TextStyle(color: Colors.white),
  floatingLabelStyle: TextStyle(color: Colors.white),
);
