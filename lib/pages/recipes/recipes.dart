import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:what2bake/globalWidgets/reloadButton.dart';
import 'package:what2bake/pages/recipes/widgets/recipeSortButton.dart';
import 'package:what2bake/pages/recipes/widgets/recipeShimmerLoading.dart';
import 'package:what2bake/services/api.dart';
import 'package:what2bake/globalWidgets/recipeCard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:what2bake/globalWidgets/toTheTopButton.dart';
import 'package:what2bake/pages/recipes/widgets/recipeFilterButton.dart';
import 'package:what2bake/services/model.dart';

class Recipes extends StatefulWidget {
  final PageController pageViewController;
  const Recipes({super.key, required this.pageViewController});
  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> with AutomaticKeepAliveClientMixin {
  late int pageNumber;
  List<dynamic> data = [];
  List<dynamic> data2 = [];
  List<dynamic> recipes = [];
  List similarity = [];
  List<int> products = [];
  List<String> favoritesId = [];
  bool isLoading = true;
  bool isMenuOpen = false;
  List<Product> allProductsData = [];
  String sortName = "PRODUCTS_PROGRESS_DESC, PRODUCTS_HAS_DESC";
  Filters filters = Filters();
  late bool ingrChange;
  Map<String, dynamic> ratings = {};
  RecipesInfo recipesInfo = RecipesInfo();
  bool isShownReload = false;
  final ScrollController scrollController = ScrollController();
  List<int> sharedPref = [];
  Future<void> loadRecInf() async {
    try {
      recipesInfo = await getRecipesInfo([], sortName, minProducts: filters.rangeValues.start.round(), maxProducts: filters.rangeValues.end.round(), rating: filters.rating, mainIngredients: filters.mainIngredients);
    } catch(e) {
      debugPrint(e.toString());
    }

  }

  Future<void> _refresh() async {
    isShownReload = false;
    data = [];
    recipes = [];
    similarity = [];
    products = [];
    pageNumber = 0;
    await loadRecInf();
    await loadPage();
    scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.easeOutCubic);

  }

  void changeSort(sN) {
    sortName = sN;
    _refresh();

  }

  void menuStateChange(state) {
    setState(() {
      isMenuOpen = state;
    });
  }

  void filterRefresh(Filters value) {
    filters = value;
    _refresh();
  }

  void changeFavoriteStatus(List<String> fIds) {
    favoritesId = fIds;
  }

  void ingredientsRefresh() {
    setState(() {
      isShownReload = true;
    });
  }

  @override
  void initState() {
    widget.pageViewController.addListener(() {
      if(widget.pageViewController.page == 1 && globals.ingredientsChange[1] == true) {
        globals.ingredientsChange[1] = false;
        setState(() {
          isLoading = true;
        });
        _refresh();
      }
    });
    pageNumber = 0;

    loadRecInf();
    if(!globals.ingredientsChange[1]) loadPage();

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
    setState(() {

    });
    if(!isShownReload) {
      final prefs = await SharedPreferences.getInstance();
       sharedPref = (prefs.getStringList('0')?.isEmpty == false) ? prefs.getStringList('0')!.map(int.parse).toList() : [0];
    }

    if(globals.isLogged) {
      ratings = await getAllRatingsId();
    }
    data = await getRecipes(sharedPref, pageNumber, [], sortName, minProducts: filters.rangeValues.start.round(), maxProducts: filters.rangeValues.end.round(), rating: filters.rating, mainIngredients: filters.mainIngredients);
    data2 = await getAllProducts();
    if(data[0] == "noNetwork" || data2[0] == "noNetwork") {
      Future.delayed(const Duration(seconds: 6), () {
        _refresh();
      });
    }
    allProductsData = data2[0];
    recipes += data[0];
    similarity += data[1];
    products += data[2];
    favoritesId = data[3];
    products = products.toSet().toList();
    if(data[0].isNotEmpty) pageNumber++;

    if(mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if(isMenuOpen) {
          setState(() {
            isMenuOpen = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          onRefresh: _refresh,
          child: (!isLoading) ? Stack(
            children: [
              CustomScrollView(
              controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        RecipeFilterButton(text: "Filtry", icon: Icons.filter_alt_outlined, refresh: filterRefresh, allProductsData: allProductsData, pressedProducts: products,),
                        RecipeSortButton(isMenuOpen, menuStateChange, changeSort),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.w,
                        crossAxisSpacing: 8.h,
                        mainAxisExtent: 310.h
                      ),
                      delegate: SliverChildBuilderDelegate( (context, index) {
                          if ((recipes.isNotEmpty)) {
                            return RecipeCard(recipes[index], similarity[index], products, favoritesId, rcs: RecipeCardSizes.recipes, ingredientsRefresh, changeFavoriteStatus, ratings, isShownReload);
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Theme.of(context).colorScheme.onPrimary,
                              highlightColor: Theme.of(context).colorScheme.surface,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red,
                                )
                          ),
                            );
                          }
                        },
                        childCount: (recipes.isNotEmpty) ? recipes.length : 3,
                      ),
                    )
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: ((recipesInfo.countWithFilters! / 20).ceil() == pageNumber) ? Text("Brak dalszych wyników", style: Theme.of(context).textTheme.displaySmall,) : const CircularProgressIndicator(),
                      ),
                    ),
                  )
                ]
            ),
            ToTheTopButton(scrollController: scrollController),
            Positioned(right: 1, child: ReloadButton(callback: _refresh, isShown: isShownReload,),)
          ]
          ) : const RecipeShimmerLoading(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

