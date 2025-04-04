import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class textField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool locked;
  final String? Function(String?) validator;
  const textField({super.key, required this.controller, required this.hintText, required this.icon, this.obscureText = false, this.locked = false, required this.keyboardType, required this.validator} );

  @override
  State<textField> createState() => _textFieldState();
}

class _textFieldState extends State<textField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
              color: Colors.black.withOpacity(0.4),
                blurRadius: 1,
                offset: const Offset(0, 0.5),
                spreadRadius: 0.1
              ),
        ],
        ),
        child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 2.h, 0, 2.h),
          child: TextFormField(
            validator: widget.validator,
            readOnly: widget.locked,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:  Theme.of(context).textTheme.labelSmall,
              suffixIcon: Icon(
                widget.icon,
                color: Theme.of(context).textTheme.labelSmall?.color,
              ),
              border: InputBorder.none,
              errorStyle: TextStyle(
                fontSize: 15.sp,
                height: 0.1.h,
                overflow: TextOverflow.fade
              )
            ),
            cursorColor: Colors.white,
            style: TextStyle(
              fontSize: 20.sp,
              color: (widget.locked) ? Theme.of(context).textTheme.titleSmall?.color!.withOpacity(0.3) : Theme.of(context).textTheme.titleSmall?.color,
              fontWeight: FontWeight.w500,
            ),
            obscureText: widget.obscureText,
          )
        )
      );
  }
}