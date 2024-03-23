import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final disable;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.disable = false,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(
      colors: [
        Colors.orangeAccent,
        Color.fromARGB(255, 251, 196, 2),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: disable ? LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.7),
            Colors.grey.withOpacity(0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ) : gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disable == true ? Colors.grey : Colors.transparent,
          shadowColor: disable == true ? Colors.grey : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
}
