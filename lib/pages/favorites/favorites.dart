import 'package:flutter/material.dart';


class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _HomeState();
}

class _HomeState extends State<Favorites> {

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      backgroundColor: Color(0xFF232323),
      body: Center(
        child: Text(
          "Favorites Page",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
