import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what2bake/services/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flex_list/flex_list.dart';
import 'package:what2bake/data/globalvar.dart' as globals;

class IngredientCard extends StatefulWidget {
  final List<Product> products;
  List<String> pressed;
  int pressedNumber;
  Function refresh;
  int index;
  IngredientCard({super.key, required this.products, required this.pressed, required this.pressedNumber, required this.index, required this.refresh});

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {

  Future<void> update(var i) async {

    if(widget.pressed.contains(widget.products[i].id.toString())) {
      widget.pressed.remove(widget.products[i].id.toString());
      widget.pressedNumber--;
      widget.refresh(widget.index, false, widget.products[i].id.toString());
    } else {
      widget.pressed.add(widget.products[i].id.toString());
      widget.pressedNumber++;
      widget.refresh(widget.index, true, widget.products[i].id.toString());
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('0', widget.pressed);
    globals.ingredientsChange = [true, true, false, true];

  }
  var kontroler = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          children: [
              Padding(
                  padding: REdgeInsets.all(20),
                  child: Row(
                      children: [
                          SvgPicture.asset(
                            'assets/categories/${widget.products[0].category!.name!}.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        Container(
                          margin: EdgeInsets.only(left: 15.w),
                          width: 190.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.products[0].category!.name!,
                                style: Theme.of(context).textTheme.titleSmall,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                              ),
                              Text(
                                '${widget.pressedNumber}/${widget.products.length} składników',
                                style: Theme.of(context).textTheme.displaySmall
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                             child: Align(
                               alignment: Alignment.centerRight,
                                 child: GestureDetector(
                                   onTap: () async {
                                     for (var i = 0; i < widget.products.length; i++) {
                                       if (widget.pressed.contains(widget.products[i].id.toString())) {
                                         widget.pressed.remove(widget.products[i].id.toString());
                                         widget.pressedNumber--;
                                         widget.refresh(widget.index, false, widget.products[i].id.toString());
                                       }
                                     }
                                     final prefs = await SharedPreferences.getInstance();
                                     await prefs.setStringList('0', widget.pressed);
                                     setState(() {

                                     });
                                     globals.ingredientsChange = [true, true, true];
                                   },
                                     child: Icon(Icons.delete, size: 40.w, color: Colors.grey,)
                                 )
                             )
                         ),

                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    height: 3.h,
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        controller: kontroler,
                        interactive: true,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: kontroler,
                          scrollDirection: Axis.vertical,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: REdgeInsets.all(10),
                              child:  FlexList(
                                      horizontalSpacing: 7.w,
                                      verticalSpacing: 7.h,
                                      children: [for (var i = 0; i < widget.products.length; i++) SizedBox(
                                        height: 35.h,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: widget.pressed.contains(widget.products[i].id.toString()) ? Theme.of(context).colorScheme.tertiary : Theme.of(context).splashColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              update(i);
                                            });
                                          },
                                          child: Text(
                                            "${widget.products[i].name[0].toUpperCase()}${widget.products[i].name.substring(1).toLowerCase()}",
                                            style: (widget.pressed.contains(widget.products[i].id.toString()) ? TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, fontFamily: 'Lato', color: Colors.white) : TextStyle(
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
                      ),
                    ),
                  ),
                ],
              )
            );
  }
}