import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:what2bake/globalWidgets/recipeCard.dart';
import 'package:what2bake/globalWidgets/toTheTopButton.dart';
import 'package:what2bake/pages/favorites/widgets/favoritesShimmerLoading.dart';
import 'package:what2bake/services/api.dart';

class Favorites extends StatefulWidget {
  final PageController pageViewController;
  const Favorites({super.key, required this.pageViewController});

  @override
  State<Favorites> createState() => _HomeState();
}

class _HomeState extends State<Favorites> with AutomaticKeepAliveClientMixin {

  late int pageNumber;
  List<dynamic> data = [];
  List<dynamic> recipes = [];
  List similarity = [];
  List<int> products = [];
  List<String> favoritesId = [];
  bool isLoading = true;
  final ScrollController scrollController = ScrollController();
  Map<String, dynamic> ratings = {};


  void changeFavoriteStatus(List<String> fIds) {
    favoritesId = fIds;
  }

  @override
  void initState() {
    pageNumber = 0;

    widget.pageViewController.addListener(() {
      if(widget.pageViewController.page == 3 && globals.ingredientsChange[3] == true) {
        globals.ingredientsChange[3] = false;
        setState(() {
          isLoading = true;
        });
        _refresh();
      }
    });

    if(globals.isLogged && !globals.ingredientsChange[3]) {
      loadPage();
    }

    scrollController.addListener(() {
      if(scrollController.offset == scrollController.position.maxScrollExtent) {
        loadPage();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future loadPage() async {
    if(globals.isLogged) {
      ratings = await getAllRatingsId();
    }
    data = await getFavorites(pageNumber);
    if(data[0] == "noNetwork") {
      Future.delayed(const Duration(seconds: 6), () {
        _refresh();
      });
    }
    recipes += data[0];
    similarity += data[1];
    products += data[2];
    favoritesId = data[3];
    products = products.toSet().toList();
    pageNumber++;

    if(mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    data = [];
    recipes = [];
    similarity = [];
    products = [];
    pageNumber = 0;
    await loadPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: (globals.isLogged) ? Container(
        child: (!isLoading) ? RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          onRefresh: _refresh,
          child: Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
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
                          return RecipeCard(recipes[index], similarity[index], products, favoritesId,
                            rcs: RecipeCardSizes.favorites, _refresh, changeFavoriteStatus, ratings, false);
                        },
                          childCount: recipes.length,

                        ),
                      ),
                    ),
                    /*SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )*/
                  ]
              ),
              ToTheTopButton(scrollController: scrollController)
          ]
          ),
        ) : const FavoritesShimmerLoading(),


        //  NOT LOGGED IN

      ) : Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.inversePrimary, size: 30.sp,),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                },
                child: Text(
                  "Zaloguj się",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20.sp,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                    "Zaloguj się aby wyświetlić\n tę treść",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
