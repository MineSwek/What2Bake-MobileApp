import 'package:flutter/material.dart';

class ToTheTopButton extends StatefulWidget {
  final ScrollController scrollController;
  const ToTheTopButton({super.key, required this.scrollController});

  @override
  State<ToTheTopButton> createState() => _ToTheTopButtonState();
}

class _ToTheTopButtonState extends State<ToTheTopButton> {
  bool opacityTopButton = false;
  bool visibilityTopButton = false;

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if(widget.scrollController.offset > 800) {
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
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            widget.scrollController.animateTo(0, duration: const Duration(seconds: 2), curve: Curves.easeOutCubic);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.onSecondary.withOpacity(0.8),
                child: Icon(Icons.keyboard_double_arrow_up, color: Theme.of(context).colorScheme.secondary,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
