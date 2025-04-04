import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTile extends StatefulWidget {
  final Function callback;
  final dynamic argument;
  final IconData icon;
  final String title;
  Widget? trailing = Icon(
    Icons.chevron_right,
    size: 30.w,
  );
  SettingsTile({super.key, required this.callback, required this.icon, required this.title, this.trailing, this.argument});

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (widget.argument != null) ? widget.callback(widget.argument) : widget.callback();

      },
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        leading: Icon(
          widget.icon,
          size: 39.w,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        trailing: widget.trailing,
        title: Text(
          widget.title,
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleSmall
        ),
        minVerticalPadding: 20.h,
        minLeadingWidth: 20.w,
      ),
    );
  }
}
