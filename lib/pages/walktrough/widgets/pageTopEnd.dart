import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WalkthroughPageTopEnd extends StatelessWidget {
  final String topString;
  final String bottomString;
  final String pageNumber;
  const WalkthroughPageTopEnd({super.key, required this.topString, required this.bottomString, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
            alignment: Alignment.topCenter,
            children: [
              Text(
                topString,
                style: TextStyle(
                    fontSize: 40.sp,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: SvgPicture.asset("assets/logo/Logo.svg", width: 280.w,),
              ),
            ]
        ),

        Text(
          bottomString,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25.sp,
              fontFamily: "Lato",
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.inversePrimary
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Image.asset("assets/walkthrough/Walkthrough_$pageNumber.png", width: ScreenUtil().screenWidth,),
        )
      ],
    );
  }
}
