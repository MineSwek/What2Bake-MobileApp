import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onPrimary,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              for(var i = 0; i < 4; i++)
                Column(
                  children: [
                    Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child:  Container(
                              width: 197.w,
                              height: 38.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.red,
                              ),
                            )
                        ),
                      ],
                    ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: SizedBox(
                            height: 250.h,
                            child: ListView.builder(
                              itemCount: 3,
                              itemExtent: 173.w,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 5.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              },
                            )
                        )
                    ),
                  ],
                ),
            ],
          ),
        )
    );
  }
}
