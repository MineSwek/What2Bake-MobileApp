import 'package:flutter/material.dart';

class AutTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  const AutTextField({Key? key, required this.controller, required this.hintText, required this.icon, this.obscureText = false}) : super(key: key);

  @override
  State<AutTextField> createState() => _AutTextFieldState();
}

class _AutTextFieldState extends State<AutTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color(0xFF393838),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 2, 0, 2),
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontFamily: "Lato",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF616161),
              ),
              suffixIcon: Icon(
                widget.icon,
                color: const Color(0xFF616161),
              ),
              border: InputBorder.none,
            ),
            cursorColor: Colors.white,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            obscureText: widget.obscureText,
          )
        )
      );
  }
}
