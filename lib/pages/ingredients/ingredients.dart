import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what2bake/pages/ingredients/widgets/ingredientsShimmerLoading.dart';
import 'package:what2bake/services/api.dart';
import 'package:what2bake/services/model.dart';
import 'package:what2bake/pages/ingredients/widgets/ingredientCard.dart';
import 'package:what2bake/data/globalvar.dart' as globals;

class Ingredients extends StatefulWidget {
  final PageController pageViewController;
  const Ingredients({super.key, required this.pageViewController});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class Products {
  int? id;
  List<Product> temp1 = [];
  List<String> temp2 = [];
}

class _IngredientsState extends State<Ingredients> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<dynamic> data = [];
  List<dynamic> productsApi = [];
  List<dynamic> categories = [];
  List<String> pressed = [];
  List<Products> products = [];
  bool isLoading = true;
  late TabController _tabController;

  void _refresh(int index, bool add, String ingredientNumber) async {
    (add) ? products[index].temp2.add(ingredientNumber) : products[index].temp2.remove(ingredientNumber);
    setState(() {

    });
  }

  Future loadProducts() async {
    if(mounted) {
      setState(() {
      isLoading = true;
    });
    }

    data = await getAllProducts();
    if(data[0] == "noNetwork") {
      Future.delayed(const Duration(seconds: 6), () {
        loadProducts();
      });
    }
    productsApi = data[0];
    pressed = data[1];
    categories = data[2];
    print(categories[0].name);

    categories.sort((a, b) => a.id.compareTo(b.id));
    for (var e in categories) {
      Products prtemp = Products();
      for (var e2 in productsApi) {
        if(e2.category.id == e.id) {
          for (var e3 in pressed) {
            if(e3 == e2.id.toString()) prtemp.temp2.add(e3);
          }
          prtemp.temp1.add(e2);
        }
      }
      products.add(prtemp);
    }
    if(mounted) {
      _tabController = TabController(length: categories.length+1, vsync: this);
      setState(() {
      isLoading = false;
    });
    }
  }

  @override
  void initState() {
    widget.pageViewController.addListener(() async {
      if(widget.pageViewController.page == 2 && globals.ingredientsChange[2] == true) {
        globals.ingredientsChange[2] = false;
        setState(() {
          isLoading = true;
        });
        products = [];
        await loadProducts();
      }
    });
    if(!globals.ingredientsChange[2]) loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: (!isLoading) ?
            Row(
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.only(left: 6.h),
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,

                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0,),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tabs: [
                        for(int index = 0; index < categories.length; index++) RotatedBox(quarterTurns: 3, child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SizedBox(
                              width: 60.w,
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/categories/${products[index].temp1[0].category!.name!}.svg',
                                      width: 35.w,
                                      height: 35.h,
                                      fit: BoxFit.cover,
                                    ),
                                    Text("${products[index].temp2.length.toString()}/${products[index].temp1.length}", style: Theme.of(context).textTheme.bodySmall,),
                                  ],
                            ),
                          ),
                        )),
                        RotatedBox(
                          quarterTurns: 3,
                          child: GestureDetector(
                              onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Czy chcesz odznaczyć?", style: TextStyle(),),
                                  content: Text("Czy na pewno chcesz odznaczyć wszystkie wybrane składniki?", style: Theme.of(context).textTheme.bodySmall,),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Anuluj", style: Theme.of(context).textTheme.displaySmall,)
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          final prefs = await SharedPreferences.getInstance();
                                          await prefs.setStringList('0', []);
                                          setState(() {

                                          });
                                          globals.ingredientsChange = [true, true, false, true];
                                          products = [];
                                          loadProducts();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Odznacz wszystko", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.amber),)
                                    ),
                                  ],
                                )),
                              child: Icon(Icons.delete, size: 40.w, color: Colors.grey,)
                          ),
                        )

                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          for(int index = 0; index < categories.length; index++) Padding(
                            padding: EdgeInsets.all(5.h),
                            child: IngredientCard(products: products[index].temp1, pressed: pressed, pressedNumber: products[index].temp2.length, index: index, refresh: _refresh,),
                          ),
                          Container(color: Colors.white,)
                      ]
                    ),
                  )
                ],
              ) : const IngredientsShimmerLoading()
    );
  }

  @override
  bool get wantKeepAlive => true;
}
