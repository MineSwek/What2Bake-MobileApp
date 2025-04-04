import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what2bake/services/model.dart';
import 'package:flex_list/flex_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what2bake/data/globalvar.dart' as globals;

class CardDialog extends StatefulWidget {
  final Function _changedIngrFunc;
  final Function _changedFavStatFunc;
  final Function _changedStarsFunc;
  final List<String> favoritesId;
  final Recipe recipe;
  int howManyProducts;
  final List<int> products;
  final Map<String, dynamic> ratings;
  final bool isShownReload;
  CardDialog(this.recipe, this.howManyProducts, this.products, this.favoritesId, this._changedIngrFunc, this._changedFavStatFunc, this._changedStarsFunc, this.ratings, this.isShownReload, {super.key, });

  @override
  State<CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  late int stars;
  Future<void> update(var i) async {

    if(widget.products.contains(widget.recipe.products![i].id)) {
      widget.products.remove(widget.recipe.products![i].id);
      widget.howManyProducts--;
    } else {
      widget.products.add(widget.recipe.products![i].id);
      widget.howManyProducts++;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('0', widget.products.map((e) => e.toString()).toList());
    globals.ingredientsChange = [true, true, true, true];
    widget._changedIngrFunc();
  }

  final ScrollKontroler = ScrollController();
  String watermarkName = "";

  @override
  void initState() {
    stars = (widget.ratings.containsKey(widget.recipe.idRec)) ? widget.ratings[widget.recipe.idRec]! : 0;
    watermarkName = ((widget.recipe.link?.substring(0, 12) == "https://www.") ? widget.recipe.link?.split('.')[1] : widget.recipe.link?.split('.')[0].substring(8))!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
              backgroundColor:  Theme.of(context).colorScheme.surface,
              insetPadding: EdgeInsets.symmetric(vertical: 72.h, horizontal: 11.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)
              ),
              child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: [

                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.recipe.image!)
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            )
                        ),

                        Visibility(
                          visible: globals.isLogged,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  String httpMethod;
                                  httpMethod = (widget.favoritesId.contains(widget.recipe.idRec)) ? "DELETE" : "POST";
                                  (widget.favoritesId.contains(widget.recipe.idRec)) ? widget.favoritesId.remove(widget.recipe.idRec) : widget.favoritesId.add(widget.recipe.idRec!);
                                  widget._changedFavStatFunc(httpMethod, true, widget.favoritesId);

                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.7),

                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.r),
                                    child: Icon((widget.favoritesId.contains(widget.recipe.idRec)) ? Icons.favorite : Icons.favorite_border, size: 35.sp, color: (widget.favoritesId.contains(widget.recipe.idRec)) ? Colors.red : Colors.white,),
                                  )
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),

                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.r),
                                child: Icon(Icons.close,size: 35.r,),
                              ),
                            ),
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 250.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    opacity: 0.4,
                                    image: AssetImage("assets/blogsLogo/$watermarkName.png"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              height: 43.h,
                              width: 257.w,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  setState(() async {
                                    await launchUrl(Uri.parse(widget.recipe.link!), mode: LaunchMode.externalApplication);
                                  });
                                },
                                child: Text(
                                  'Zobacz przepis',
                                  style: Theme.of(context).textTheme.displayMedium
                                ),
                              ),
                            ),
                            Container(
                              margin: REdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Text(
                                widget.recipe.title!,
                                style: Theme.of(context).textTheme.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Przepis pochodzi ze strony: $watermarkName",
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            (globals.isLogged) ? Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: SizedBox(
                                width: ScreenUtil().screenWidth,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(stars != 0) GestureDetector(
                                      onTap: () {
                                        stars = 0;
                                        widget._changedStarsFunc(stars);
                                        setState(() {

                                        });
                                      },
                                      child: Icon(Icons.remove_circle_outline, size: 22.sp, color: Colors.grey,),
                                    ),
                                    for(int i = 1; i < 6; i++) GestureDetector(
                                        onTap: () {
                                          stars = i;
                                          widget._changedStarsFunc(stars);
                                          setState(() {

                                          });
                                        },
                                        child: Icon(Icons.star, size: 28.sp, color: (i <= stars) ? Theme.of(context).colorScheme.secondary : Colors.grey,)
                                    ),

                                  ],
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: REdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: REdgeInsets.all(20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/categories/Zboża i Produkty sypkie.svg',
                                    width: 40.w,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 15.w),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Składniki',
                                              style: Theme.of(context).textTheme.titleSmall
                                            ),
                                            Text(
                                              '${widget.howManyProducts.toString()}/${widget.recipe.products!.length} składników',
                                              style: Theme.of(context).textTheme.displaySmall
                                            ),


                                          ],
                                        ),
                                        (widget.isShownReload) ? Padding(
                                          padding: EdgeInsets.only(left: 30.0.w),
                                          child: Column(
                                            children: [
                                              Text("Zmieniono posiadane składniki.", style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500),),
                                              Text("Odśwież stronę", style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500),)
                                            ],
                                          ),
                                        ) : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Theme.of(context).colorScheme.surface,
                              height: 3,
                            ),
                            Expanded(
                                flex: 3,
                                child: Scrollbar(
                                  controller: ScrollKontroler,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: ScrollKontroler,
                                    scrollDirection: Axis.vertical,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: REdgeInsets.all(10),
                                        child: FlexList(
                                            horizontalSpacing: 8.w,
                                            verticalSpacing: 8.h,
                                            children: [for (var i = 0; i < widget.recipe.products!.length; i++) SizedBox(
                                              height: 38.h,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: widget.products.contains(widget.recipe.products![i].id) ?  Theme.of(context).colorScheme.tertiary : Theme.of(context).splashColor,
                                                ),
                                                onPressed: () {

                                                  setState(() {
                                                    update(i);
                                                  });

                                                },
                                                child: Text(
                                                  "${widget.recipe.products![i].name[0].toUpperCase()}${widget.recipe.products![i].name.substring(1).toLowerCase()}",
                                                  style: (widget.products.contains(widget.recipe.products![i].id) ? TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, fontFamily: 'Lato', color: Colors.white) : TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Theme.of(context).colorScheme.inversePrimary,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                                ),
                                              ),
                                            ),
                                            ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
      );
  }
}
