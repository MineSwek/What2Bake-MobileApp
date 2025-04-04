import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what2bake/services/api.dart';
import 'package:what2bake/services/model.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:what2bake/globalWidgets/recipeCardDialog.dart';
import 'package:what2bake/data/globalvar.dart' as globals;

enum RecipeCardSizes{
  recipes(imageSize: 240, titleRowSize: 320, titleFontSize: 16, reviewBoxWidth: 52, reviewBoxHeight: 22,
      reviewIconSize: 18, reviewTextSize: 15, reviewCountWidth: 60, reviewPaddingTop: 7, progressWidth: 50),

  home(imageSize: 186, titleRowSize: 120, titleFontSize: 16, reviewBoxWidth: 46, reviewBoxHeight: 18,
  reviewIconSize: 16, reviewTextSize: 14, reviewCountWidth: 50, reviewPaddingTop: 4, progressWidth: 43),

  favorites(imageSize: 186, titleRowSize: 120, titleFontSize: 16, reviewBoxWidth: 46, reviewBoxHeight: 18,
  reviewIconSize: 16, reviewTextSize: 14, reviewCountWidth: 50, reviewPaddingTop: 4, progressWidth: 61);

  const RecipeCardSizes({
    required this.imageSize,
    required this.titleRowSize,
    required this.titleFontSize,
    required this.reviewBoxWidth,
    required this.reviewBoxHeight,
    required this.reviewIconSize,
    required this.reviewTextSize,
    required this.reviewCountWidth,
    required this.reviewPaddingTop,
    required this.progressWidth,
  });

  final double imageSize;
  final double titleRowSize;
  final double titleFontSize;
  final double reviewBoxWidth;
  final double reviewBoxHeight;
  final double reviewIconSize;
  final double reviewTextSize;
  final double reviewCountWidth;
  final double reviewPaddingTop;
  final double progressWidth;
}



class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final int howManyProducts;
  final List<int> products;
  final RecipeCardSizes rcs;
  final Function _refresh;
  final Function changeFavoriteStatus;
  final List<String> favoritesId;
  final Map<String, dynamic> ratings;
  final bool isShownReload;
  const RecipeCard(this.recipe, this.howManyProducts, this.products, this.favoritesId, this._refresh, this.changeFavoriteStatus, this.ratings, this.isShownReload, {super.key, required this.rcs, });


  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {

  final ScrollKontroler = ScrollController();
  var asdsdsa = RecipeCardSizes.recipes.imageSize;
  late Color? col;
  bool isImageLoaded = false;
  String watermarkName = "";

  @override
  void initState() {
    watermarkName = ((widget.recipe.link?.substring(0, 12) == "https://www.") ? widget.recipe.link?.split('.')[1] : widget.recipe.link?.split('.')[0].substring(8))!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.howManyProducts == 0) {
      col = Theme.of(context).colorScheme.error;
    } else if (widget.howManyProducts == widget.recipe.products!.length) {
      col = Colors.green;
    } else {
      col = Theme.of(context).textTheme.headlineLarge!.color;
    }

    var changedIngr = false;
    var changedStars = false;
    int starsCount = 0;
    void changedIngrFunc() => changedIngr = true;
    void changedStarsFunc(int stars) {
      changedStars = true;
      starsCount = stars;
      setState(() {

      });
    }
    var changedFavStat = [false, "POST", []];
    void changedFavStatFunc(String httpMethod, bool changedStatus,
        List<String> fIds) {
      changedFavStat = [changedStatus, httpMethod, fIds];
    }

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return CardDialog(widget.recipe, widget.howManyProducts, widget.products, widget.favoritesId, changedIngrFunc, changedFavStatFunc, changedStarsFunc, widget.ratings, widget.isShownReload);
            }).then((value) async {
          if (changedIngr) {
            changedIngr = false;
            widget._refresh();
          }
          if (changedStars && globals.isLogged) {
            changedStars = false;
            (starsCount != 0) ? await changeRating("POST", starsCount, widget.recipe.idRec!) : await changeRating("DELETE", starsCount, widget.recipe.idRec!);
            globals.ingredientsChange = [true, false, false, true];
            widget._refresh();

          }
          if (changedFavStat[0] == true) {
            changedFavStat[0] = false;
            widget.changeFavoriteStatus(changedFavStat[2]);
            changeFavoriteRecipeStatus(
                changedFavStat[1].toString(), widget.recipe.idRec!);
            globals.ingredientsChange = [true, true, false, true];
          }
        });
      },
      child: Material(
        elevation: 2,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: SizedBox(
          width: 150.w,
          child: Column(
            children: [
              Container(
                height: widget.rcs.imageSize.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      children: [
                        Image.network(
                          widget.recipe.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: widget.rcs.imageSize.h,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image has loaded successfully
                              Future.delayed(const Duration(milliseconds: 0), () {
                                if(mounted) {
                                  setState(() {
                                    isImageLoaded = true;
                                  });
                                }

                              });
                              return child;
                            } else {
                              // Image is still loading
                              return Container();
                            }
                          },
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            // Error occurred while loading the image
                            return const Text('Failed to load image');
                          },
                        ),
                        if (isImageLoaded) // Show overlay text only when the image has loaded
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

                      ],
                    ),
                  ),
                )
              ),

              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: widget.rcs.titleRowSize.w,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    3.w, 8.h, 0.w, 3.h),
                                child: Text(
                                  widget.recipe.title!,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: widget.rcs.titleFontSize.sp,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(3.w, 0, 0, 0),
                                  child: Container(
                                    width: widget.rcs.reviewBoxWidth.w,
                                    height: widget.rcs.reviewBoxHeight.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(15.r)
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 1.h),
                                          child: Icon(
                                            Icons.star,
                                            color: Theme.of(context).colorScheme.onSecondary,
                                            size: widget.rcs.reviewIconSize.h,
                                          ),
                                        ),
                                        Text(
                                          widget.recipe.rating!.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSecondary,
                                              fontSize: widget.rcs.reviewTextSize.sp
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      5.w, widget.rcs.reviewPaddingTop.h, 0, 0),
                                  child: SizedBox(
                                    width: widget.rcs.reviewCountWidth.w,
                                    height: widget.rcs.reviewBoxHeight.h,
                                    child: Text(
                                      "${widget.recipe.rating_count.toString()} opinii",
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.displaySmall?.color,
                                        fontSize: widget.rcs.reviewTextSize.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      width: widget.rcs.progressWidth.w,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 4.h, 2.w, 0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: DashedCircularProgressBar.square(
                              dimensions: 50.r,
                              progress: widget.howManyProducts.toDouble(),
                              maxProgress: widget.recipe.products!.length.toDouble(),
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                              startAngle: 11.r,
                              backgroundColor: Theme.of(context).colorScheme.onSurface,
                              foregroundStrokeWidth: 4.w,
                              backgroundStrokeWidth: 4.w,
                              foregroundGapSize: 20,
                              foregroundDashSize: 360 / (widget.recipe.products!.length + 0.01) - 20,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    shape: BoxShape.circle
                                ),
                                child: Center(
                                  child: Text(
                                    "${widget.howManyProducts}/${widget.recipe.products!.length}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: col,
                                        fontSize: 16.sp
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}