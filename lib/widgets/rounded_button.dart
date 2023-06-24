import 'package:flutter/material.dart';
import 'package:open_workouts/utilities/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color? textColour;
  final Color? backgroundColor;
  final Color? overlayColor;
  final Color? shadowColor;
  final Size? fixedSize;
  final VoidCallback? onPressed;
  final Widget? child;

  const RoundedButton({
    Key? key,
    required this.text,
    this.textColour = Colors.white,
    this.backgroundColor = ThemeColors.kPurple,
    this.overlayColor = ThemeColors.kLightPurple,
    this.shadowColor = ThemeColors.kPurple,
    this.fixedSize = const Size(412, 60),
    this.onPressed,
    this.child,
  }) : super(key: key);

  Widget? getWidget() {
    if (child != null) {
      return child;
    }
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textColour, fontSize: 20.0, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2),
        overlayColor: MaterialStateProperty.all(overlayColor),
        shadowColor: MaterialStateProperty.all(shadowColor),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        fixedSize: MaterialStateProperty.all(fixedSize),
      ),
      child: getWidget(),
    );
  }
}
