import 'package:flex_list/flex_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:what2bake/pages/recipes/widgets/searchbar.dart';
import 'package:what2bake/services/model.dart';

class Filters {
  SfRangeValues rangeValues = const SfRangeValues(1, 20);
  List<Product> mainIngredients = [];
  int rating = 0;
}

class RecipeFilterButton extends StatefulWidget {
  final String text;
  final IconData icon;
  Function refresh;
  final List<Product> allProductsData;
  final List<int> pressedProducts;


  RecipeFilterButton({super.key, required this.text, required this.icon, required this.refresh, required this.allProductsData, required this.pressedProducts});

  @override
  State<RecipeFilterButton> createState() => _RecipeFilterButtonState();
}

class _RecipeFilterButtonState extends State<RecipeFilterButton> {
  Filters filters = Filters();

  void ratingCallback(int index) {
    setState(() {
      filters.rating = index;
    });
  }

  void mainIngredientsCallback(int id, String name) {
    setState(() {
      Product temp = Product(id: id, name: name);
      if(!filters.mainIngredients.map((e) => e.id).toList().contains(id)) {
        filters.mainIngredients.add(temp);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 5.h, 0, 0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8.w))
          ),
          onPressed: () {
            showDialog(context: context, builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Dialog(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    insetPadding: EdgeInsets.symmetric(
                        vertical: 72.h, horizontal: 11.w
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child: Listener(
                      onPointerDown: (PointerDownEvent d) {
                        FocusScope.of(context).unfocus();
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filtry",
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  GestureDetector(
                                    child: Icon(Icons.close, size: 40.sp,),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Ilość składników",
                                              style: Theme.of(context).textTheme.titleSmall,
                                            ),
                                            Text(
                                              "${filters.rangeValues.start.round()} - ${filters.rangeValues.end.round()}",
                                              style: Theme.of(context).textTheme.titleSmall,
                                            )
                                          ],
                                        ),

                                        SfRangeSliderTheme(
                                          data: SfRangeSliderThemeData(
                                            thumbColor: Colors.white,
                                            thumbRadius: 12,
                                            thumbStrokeColor: Theme.of(context).colorScheme.secondary,
                                            thumbStrokeWidth: 5,
                                            activeTrackColor: Theme.of(context).colorScheme.secondary
                                          ),
                                          child: SfRangeSlider(
                                            min: 1,
                                            max: 20,
                                            stepSize: 1,
                                            values: filters.rangeValues,
                                            interval: 4,
                                            showTicks: true,
                                            showLabels: true,
                                            minorTicksPerInterval: 1,
                                            onChanged: (SfRangeValues values) {
                                              setState(() {
                                                filters.rangeValues = values;
                                              });
                                            },

                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        //MAIN INGREDIENTS

                                        Padding(
                                          padding: EdgeInsets.only(bottom: 15.h),
                                          child: Text(
                                            "Główne składniki",
                                            style: Theme.of(context).textTheme.titleSmall,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),

                                        //SEARCH BAR

                                        SearchBarWidget(allProductsData: widget.allProductsData, callback: mainIngredientsCallback, pressedProducts: widget.pressedProducts,),

                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: FlexList(
                                              horizontalSpacing: 7.w,
                                              verticalSpacing: 7.h,
                                              children: [for (var i = 0; i < filters.mainIngredients.length; i++) SizedBox(
                                                height: 35.h,
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
                                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(18.0),
                                                        )
                                                    )
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      filters.mainIngredients.remove(filters.mainIngredients[i]);
                                                    });
                                                  },
                                                  child: Text(
                                                    "${filters.mainIngredients[i].name[0].toUpperCase()}${filters.mainIngredients[i].name.substring(1).toLowerCase()}",
                                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary)
                                                    ),
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Oceny (większe lub równe)",
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              for(int i = 1; i <= 5; i++)
                                              GestureDetector(
                                                onTap: () {
                                                    setState(() {
                                                      if(filters.rating == i) {
                                                        filters.rating = 0;
                                                      } else {
                                                        filters.rating = i;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Theme.of(context).colorScheme.primary),
                                                        color: (i == filters.rating) ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                                        borderRadius: BorderRadius.circular(20.sp)
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            i.toString(),
                                                            style: Theme.of(context).textTheme.titleSmall,
                                                          ),
                                                          Icon(Icons.star, color: Theme.of(context).colorScheme.secondary, size: 20.sp,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              );
            }).then((value) {
              widget.refresh(filters);
            });
          },
          child: Row(
            children: [
              Icon(
                widget.icon, size: 30.w, color: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(width: 5.w,),
              Text(
                widget.text,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w500),
              )
            ],
          )
      ),
    );
  }
}
