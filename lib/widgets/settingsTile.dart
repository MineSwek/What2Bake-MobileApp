import 'package:flutter/material.dart';

class SettingsTile extends StatefulWidget {
  final width;
  final height;
  final localisation;
  final icon;
  final title;
  const SettingsTile({super.key, this.width, this.height, this.localisation, this.icon, this.title, });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, widget.localisation);
      },
      child: ListTile(
        tileColor: const Color(0xFF232323),
        leading: Icon(
          widget.icon,
          size: widget.width/10,
          color: const Color(0xFF616161),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: widget.width/12,
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
