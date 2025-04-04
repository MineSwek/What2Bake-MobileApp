import 'package:flutter/material.dart';

class ReloadButton extends StatefulWidget {
  final Function callback;
  final bool isShown;
  const ReloadButton({super.key, required this.callback, required this.isShown});

  @override
  State<ReloadButton> createState() => _ReloadButtonState();
}

class _ReloadButtonState extends State<ReloadButton> {
  bool opacityTopButton = false;
  bool visibilityTopButton = false;

  @override
  Widget build(BuildContext context) {
    if(widget.isShown) {
      if(mounted) {
        setState(() {
          opacityTopButton = true;
          visibilityTopButton = true;
        });
      }
    } else {
      if(mounted) {
        setState(() {
          opacityTopButton = false;
        });
      }
    }
    return Visibility(
      visible: visibilityTopButton,
      maintainState: true,
      maintainAnimation: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
        opacity: opacityTopButton ? 1.0 : 0.0,
        onEnd: () {
          if(!opacityTopButton) visibilityTopButton = false;
        },
        child: GestureDetector(
          onTap: () {
            widget.callback();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onSecondary.withOpacity(0.8),
                child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.secondary,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
