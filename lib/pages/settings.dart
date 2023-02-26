import 'package:flutter/material.dart';
import 'package:what2bake/widgets/appbar.dart';

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
      body: Column(
        children: [
          SizedBox(height: height/7, child: const Appbar(searchBarState: false, isSettingsPage: true,)),
          Padding(
            padding: EdgeInsets.fromLTRB(width/25, height/35, 0, height/30),
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

          /* ZALOGUJ SIĘ */

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
            child: ListTile(
              tileColor: const Color(0xFF232323),
              leading: Icon(
                  Icons.account_circle_outlined,
                size: width/10,
                color: const Color(0xFF616161),
              ),
              trailing: Icon(
                  Icons.chevron_right,
                size: width/10,
              ),
              title: const Text(
                  "Zaloguj się",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
            child: const Divider(
              color: Color(0xFF393939),
              thickness: 3.0,
            ),
          ),

          /*POWIADOMIENIA*/

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/notifications");
            },
            child: ListTile(
              tileColor: const Color(0xFF232323),
              leading: Icon(
                Icons.notifications_none_outlined,
                size: width/10,
                color: const Color(0xFF616161),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: width/10,
              ),
              title: const Text(
                "Powiadomienia",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
            child: const Divider(
              color: Color(0xFF393939),
              thickness: 3.0,
            ),
          ),


          /*ZMIEŃ MOTYW*/

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/changetheme");
            },
            child: ListTile(
              tileColor: const Color(0xFF232323),
              leading: Icon(
                Icons.colorize_outlined,
                size: width/10,
                color: const Color(0xFF616161),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: width/10,
              ),
              title: const Text(
                "Zmień motyw",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
            child: const Divider(
              color: Color(0xFF393939),
              thickness: 3.0,
            ),
          ),


          /*POMOC*/

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/help");
            },
            child: ListTile(
              tileColor: const Color(0xFF232323),
              leading: Icon(
                Icons.help_outline,
                size: width/10,
                color: const Color(0xFF616161),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: width/10,
              ),
              title: const Text(
                "Pomoc",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
            child: const Divider(
              color: Color(0xFF393939),
              thickness: 3.0,
            ),
          ),


          /*O NAS*/

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/aboutus");
            },
            child: ListTile(
              tileColor: const Color(0xFF232323),
              leading: Icon(
                Icons.info_outline_rounded,
                size: width/10,
                color: const Color(0xFF616161),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: width/10,
              ),
              title: const Text(
                "O nas",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
            child: const Divider(
              color: Color(0xFF393939),
              thickness: 3.0,
            ),
          ),


          /*DOCEŃ NASZĄ PRACĘ*/

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/tips");
            },
            child: ListTile(
              tileColor: const Color(0xFF232323),
              leading: Icon(
                Icons.coffee_outlined,
                size: width/10,
                color: const Color(0xFF616161),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: width/10,
              ),
              title: const Text(
                "Doceń naszą pracę",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(width/6, 0, width/15, 0),
            child: const Divider(
              color: Color(0xFF393939),
              thickness: 3.0,
            ),
          ),

        ],
      ),
    );
  }
}
