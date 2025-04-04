import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WalkthroughPageMiddle extends StatelessWidget {
  final String topString;
  final String pageNumber;
  const WalkthroughPageMiddle({super.key, required this.topString, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: SvgPicture.asset("assets/logo/Logo.svg", width: 280.w,),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
          child: Text(
            topString,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.sp,
              fontFamily: "Lato",
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary


            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.h),
          child: Image.asset("assets/walkthrough/Walkthrough_$pageNumber.png", width: ScreenUtil().screenWidth,),
        )
      ],
    );
  }
}
