import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class RecipeShimmerLoading extends StatelessWidget {
  const RecipeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onPrimary,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Stack(
            children: [
              CustomScrollView(
                  controller: ScrollController(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 11.h),
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child:  Container(
                                  width: 93.w,
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.red,
                                  ),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child:  Container(
                                  width: 101.w,
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
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.w,
                            crossAxisSpacing: 8.h,
                            mainAxisExtent: 315.h
                        ),
                        delegate: SliverChildBuilderDelegate( (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.red,
                              )
                          );
                        },
                          childCount: 3,
                        ),
                      ),
                    ),

                  ]
              ),
            ]
        )
    );
  }
}
