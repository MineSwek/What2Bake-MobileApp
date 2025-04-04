import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class IngredientsShimmerLoading extends StatelessWidget {
  const IngredientsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onPrimary,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  for(int index = 0; index < 12; index++) Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 5.h, 5.w, 0.h),
                    child: Container(
                      width: 60.w,
                      height: 66.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0.sp),
                        color: Colors.red
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Padding(
                  padding: REdgeInsets.all(6.sp),
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red
                    ),
                  ),
                )
            )
          ],
        )
    );
  }
}
