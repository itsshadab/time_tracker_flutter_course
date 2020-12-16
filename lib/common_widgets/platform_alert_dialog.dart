import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget{

  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;
  PlatformAlertDialog({@required this.title, @required this.content, @required this.defaultActionText, this.cancelActionText}) : assert (title != null) , assert(content != null), assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS ? await showCupertinoDialog(context: context, builder: (context) => this) : await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>this,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }
  List<Widget> _buildActions(BuildContext context){
    final action = <Widget>[];
    if(cancelActionText != null){
      action.add(
          PlatformAlertDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
      );
    }
    action.add(
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      )
    );
    return action;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;
  PlatformAlertDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}