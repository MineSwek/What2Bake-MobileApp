import 'package:flutter/material.dart';
import 'package:what2bake/globalWidgets/appbar.dart';
import 'package:what2bake/pages/settings/widgets/settingsTile.dart';
import 'package:what2bake/data/globalvar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final divider = Container(
      margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
      child: const Divider(
        color: Color(0xFF303030),
        thickness: 3.0,
      ),
    );
    /*
    return Scaffold(
      appBar: AppBar(
        title: Text("Geeks For Geeks"),
        backgroundColor: Colors.green,
      ),

      // checking the orientation
      body: orientation == Orientation.portrait?Container(
        color: Colors.blue,
        height: height/4,
        width: width/4,
      ):Container(
        height: height/3,
        width: width/3,
        color: Colors.red,
      ),
    );
     */
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: ListView(
        children: [
          SizedBox(
            height: height / 7,
            child: const Appbar(
              searchBarState: false,
              isSettingsPage: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(width / 25, height / 35, 0, height / 30),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ustawienia",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          (!pb.authStore.isValid)
              ? SettingsTile(
            width: width,
            height: height,
            localisation: "/login",
            icon: Icons.login_outlined,
            title: "Zaloguj się",
          )
              : SettingsTile(
                width: width,
                height: height,
                localisation: "/",
                icon: Icons.login_outlined,
                title: "Wyloguj się",
              ),
          divider,
          SettingsTile(
            width: width,
            height: height,
            localisation: "/notifications",
            icon: Icons.notifications_none_outlined,
            title: "Powiadomienia",
          ),
          divider,
          SettingsTile(
            width: width,
            height: height,
            localisation: "/changetheme",
            icon: Icons.remove_red_eye_outlined,
            title: "Zmień motyw",
          ),
          divider,
          SettingsTile(
            width: width,
            height: height,
            localisation: "/help",
            icon: Icons.help_outline,
            title: "Pomoc",
          ),
          divider,
          SettingsTile(
            width: width,
            height: height,
            localisation: "/aboutus",
            icon: Icons.info_outline_rounded,
            title: "O nas",
          ),
          divider,
          SettingsTile(
            width: width,
            height: height,
            localisation: "/tips",
            icon: Icons.coffee_outlined,
            title: "Doceń naszą pracę",
          ),
          divider,
        ],
      ),
    );
  }
}
