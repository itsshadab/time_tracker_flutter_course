import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  final Widget child;
  final Color color;
  final double height;
  final double boarderRadius;
  final VoidCallback onPressed;

  CustomRaisedButton({
    this.child,
    this.color,
    this.height: 50.0,
    this.boarderRadius:2.0,
    this.onPressed});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(boarderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
