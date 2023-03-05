import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what2bake/services/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flex_list/flex_list.dart';

class IngredientCard extends StatefulWidget {
  final List<Product> products;
  final List<String> pressed;
  int pressedNumber;
  IngredientCard({super.key, required this.products, required this.pressed, required this.pressedNumber});

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {


  Future<void> update() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('0', widget.pressed);
  }
  var kontroler = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF393838),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/categories/${widget.products[0].category!.name!}.svg',
                          width: 40,
                          height: 40,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.products[0].category!.name!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.pressedNumber}/${widget.products.length} składników',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Lato',
                                  color: Color(0xFFB7B7B7),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFF232323),
                    height: 3,
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
                                padding: const EdgeInsets.all(10),
                                child:  FlexList(
                                        horizontalSpacing: 8,
                                        verticalSpacing: 8,
                                        children: [for (var i = 0; i < widget.products.length; i++) SizedBox(
                                          height: 38,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: widget.pressed.contains(widget.products[i].id.toString()) ? const Color(0xFF607C08) : const Color(0xFF505050),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if(widget.pressed.contains(widget.products[i].id.toString())) {
                                                  widget.pressed.remove(widget.products[i].id.toString());
                                                  widget.pressedNumber--;
                                                } else {
                                                  widget.pressed.add(widget.products[i].id.toString());
                                                  widget.pressedNumber++;
                                                }
                                                update();
                                              });
                                            },
                                            child: Text(
                                              "${widget.products[i].name[0].toUpperCase()}${widget.products[i].name.substring(1).toLowerCase()}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFD1D1D1),
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
                      )
                  ),
                ],
              )
            );
  }
}