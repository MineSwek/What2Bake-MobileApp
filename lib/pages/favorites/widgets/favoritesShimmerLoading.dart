import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesShimmerLoading extends StatelessWidget {
  const FavoritesShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onPrimary,
        highlightColor: Theme.of(context).colorScheme.surface,
        child: Stack(
            children: [
              CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: ScrollController(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8.w,
                            crossAxisSpacing: 8.h,
                            mainAxisExtent: 250.h
                        ),
                        delegate: SliverChildBuilderDelegate( (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.red,
                              )
                          );
                        },
                          childCount: 6,

                        ),
                      ),
                    ),
                  ]
              ),
            ]
        ),
    );
  }
}
