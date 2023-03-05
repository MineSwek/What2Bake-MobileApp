import 'package:flutter/material.dart';
import 'package:what2bake/data/globalvar.dart';

class SettingsTile extends StatefulWidget {
  final double width;
  final double height;
  final String localisation;
  final IconData icon;
  final String title;
  const SettingsTile({super.key, required this.width, required this.height, required this.localisation, required this.icon, required this.title, });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.localisation != "/") {
          Navigator.pushNamed(context, widget.localisation);
        } else {
          pb.authStore.clear();
          Navigator.pushNamed(context, widget.localisation);
        }
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
