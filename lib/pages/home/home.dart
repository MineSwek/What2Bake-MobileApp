import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:what2bake/globalWidgets/recipeCard.dart';
import 'package:what2bake/globalWidgets/reloadButton.dart';
import 'package:what2bake/globalWidgets/toTheTopButton.dart';
import 'package:what2bake/pages/home/widgets/homeShimmerLoading.dart';
import 'package:what2bake/services/model.dart';
import 'package:what2bake/services/api.dart';

class Home extends StatefulWidget {
  final PageController pageViewController;
  const Home({super.key, required this.pageViewController});

  @override
  State<Home> createState() => _HomeState();
}

class TagRecipes {
  ScrollController controller = ScrollController();
  int pageNumber = 0;
  List<Recipe> recipes = [];
  List similarity = [];
  List<int> products = [];
  List<String> favoritesId = [];
  static List<Product> userProducts = [];
  RecipesInfo recipesInfo = RecipesInfo();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin{

  List<dynamic> tags = [];
  List<TagRecipes> tagsData = [];
  bool isLoading = true;
  List<String> favoritesId = [];
  ScrollController scrollController = ScrollController();
  Map<String, dynamic> ratings = {};
  bool isReload = true;
  bool isShownReload = false;
  List<int> sharedPref = [];

  Future<void> _refresh() async {
    isShownReload = false;
    tags = [];
    tagsData = [];
    isReload = true;
    await loadTags();
  }


  Future<void> loadRecInf(tagRecipes, List<int> tags, String sortName) async {
    try {
      tagRecipes.recipesInfo = await getRecipesInfo(tags, sortName);
    } catch(e) {
      debugPrint(e.toString());
    }

  }

  Future<void> loadTags() async {

    setState(() {
      isLoading = true;
    });

    tags = await getAllTags();
    if(tags[0] == "noNetwork") {
      Future.delayed(const Duration(seconds: 6), () {
        _refresh();
      });
    }
    tags.insert(0, Tag(0, "Popularne przepisy"));

    if(globals.isLogged) {
      ratings = await getAllRatingsId();
    }

    for(var x = 0; x < tags.length; x++) {

      if(!isShownReload) {
        final prefs = await SharedPreferences.getInstance();
        sharedPref = (prefs.getStringList('0')?.isEmpty == false) ? prefs.getStringList('0')!.map(int.parse).toList() : [0];
      }
      TagRecipes listViewData = TagRecipes();
      List<dynamic> data = (x == 0) ? await getRecipes(sharedPref, listViewData.pageNumber, [ ], "RATING_DESC") : await getRecipes(sharedPref, listViewData.pageNumber, [tags[x].id!], " ");
      if(isReload) {
        (x == 0) ? await loadRecInf(listViewData, [ ], "RATING_DESC") : await loadRecInf(listViewData, [tags[x].id!], " ");
      }
      listViewData.recipes += data[0];
      listViewData.similarity += data[1];
      listViewData.products += data[2];
      favoritesId = data[3];
      listViewData.products = listViewData.products.toSet().toList();
      if(data[0].isNotEmpty) listViewData.pageNumber++;

      listViewData.controller.addListener(() async {
        if(listViewData.controller.offset == listViewData.controller.position.maxScrollExtent) {
          if(!isShownReload) {
            final prefs = await SharedPreferences.getInstance();
            sharedPref = (prefs.getStringList('0')?.isEmpty == false) ? prefs.getStringList('0')!.map(int.parse).toList() : [0];
          }
          List<dynamic> data = (x == 0) ? await getRecipes(sharedPref, listViewData.pageNumber, [ ], "RATING_DESC") : await getRecipes(sharedPref, listViewData.pageNumber, [tags[x].id!], " ");
          listViewData.recipes += data[0];
          listViewData.similarity += data[1];
          listViewData.products += data[2];
          favoritesId = data[3];
          listViewData.products = listViewData.products.toSet().toList();
          if(data[0].isNotEmpty) listViewData.pageNumber++;
        }
        setState(() {

        });
      });
      tagsData.add(listViewData);
    }
    if(mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
    getAllRatingsId();
    widget.pageViewController.addListener(() {
      if(widget.pageViewController.page == 0 && globals.ingredientsChange[0] == true) {
        globals.ingredientsChange[0] = false;
        setState(() {
          isLoading = true;
        });
        _refresh();
      }
    });
    isReload = true;
    if(!globals.ingredientsChange[0]) loadTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        onRefresh: _refresh,
        child: Stack(
          children: [
            SingleChildScrollView(
            controller: scrollController,
            child: (!isLoading) ? Column(
              children: [

                //GREETING OF THE USER
                (globals.isLogged) ?
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 13.h, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Witaj, ${globals.pbUserData.data["name"]}",
                      style: Theme.of(context).textTheme.headlineLarge
                    ),
                  ),
                ) : Container(),

                //CATEGORIES

                for(int i = 0; i < tagsData.length; i++) Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.w, 10.h, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          tags[i].name!,
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          itemCount: tagsData[i].recipes.length + 1,
                          itemExtent: 173.w,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          scrollDirection: Axis.horizontal,
                          controller: tagsData[i].controller,
                          itemBuilder: (context, index) {
                            try {
                              return (index != tagsData[i].recipes.length) ? Padding(
                                padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 5.h),
                                child: RecipeCard(tagsData[i].recipes[index], tagsData[i].similarity[index], tagsData[i].products, favoritesId, rcs: RecipeCardSizes.home, ingredientsRefresh, changeFavoriteStatus, ratings, isShownReload),
                              ) : Padding(
                                padding: EdgeInsets.fromLTRB(0, 5.h, 8.w, 5.h),
                                child: Center(
                                    child: ((tagsData[i].recipesInfo.countWithFilters! / 20).ceil() == tagsData[i].pageNumber) ? Text("Brak dalszych wyników", style: Theme.of(context).textTheme.displaySmall,) : const CircularProgressIndicator(),
                                ),
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            return null;

                          },
                        )
                      )
                    ),
                  ],
                ),

            ]
          ) : const HomeShimmerLoading()

            ),
            ToTheTopButton(scrollController: scrollController),
            Positioned(right: 1, child: ReloadButton(callback: _refresh, isShown: isShownReload,),)
          ]
        ),
      )

    );
  }

  @override
  bool get wantKeepAlive => true;
}
