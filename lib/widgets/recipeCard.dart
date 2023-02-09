import 'package:flutter/material.dart';
import '../services/model.dart';
import 'package:flex_list/flex_list.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipes;
  final int howManyProducts;
  final List<int> products;
  final Color col;
  const RecipeCard(this.recipes, this.howManyProducts, this.products, this.col, {super.key});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {

  final ScrollKontroler = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: const Color(0xFF242323),
                insetPadding: const EdgeInsets.symmetric(vertical: 90, horizontal: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.recipes.image!)
                              ),
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Color(0xFF302F2F)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 47,
                                width: 257,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                  ),
                                  onPressed: () {
                                    setState(() async {
                                      await launch(widget.recipes.link!);
                                    });
                                  },
                                  child: const Text(
                                    'Zobacz przepis',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  widget.recipes.title!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: Container(
                          margin: const EdgeInsets.all(10),
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
                                      'assets/categories/Zboża i Produkty sypkie.svg',
                                      width: 40,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Składniki',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Lato',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${widget.howManyProducts.toString()}/${widget.recipes.products!.length} składników',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Lato',
                                              color: Color(0xFFB7B7B7),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: const Color(0xFF232323),
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
                                          padding: const EdgeInsets.all(10),
                                          child: FlexList(
                                              horizontalSpacing: 8,
                                              verticalSpacing: 8,
                                              children: [for (var i = 0; i < widget.recipes.products!.length; i++) SizedBox(
                                                height: 38,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: widget.products.contains(widget.recipes.products![i].id) ? const Color(0xFF607C08) : const Color(0xFF505050),
                                                  ),
                                                  onPressed: () {

                                                  },
                                                  child: Text(
                                                    "${widget.recipes.products![i].name[0].toUpperCase()}${widget.recipes.products![i].name.substring(1).toLowerCase()}",
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
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF393838),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.recipes.image!)
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFF393838),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 60, 8),
                        child: Text(
                          widget.recipes.title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  )
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 20),
                    child: DashedCircularProgressBar.square(
                        dimensions: 50,
                        progress: widget.howManyProducts.toDouble(),
                        maxProgress: widget.recipes.products!.length.toDouble(),
                        foregroundColor: Colors.amber,
                        startAngle: 10,
                        backgroundColor: const Color(0xff484646),
                        foregroundStrokeWidth: 5,
                        backgroundStrokeWidth: 5,
                        foregroundGapSize: 20,
                        foregroundDashSize: 360/(widget.recipes.products!.length+0.01)-20,
                        animation: true,
                        animationDuration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff393838),
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Text(
                              "${widget.howManyProducts}/${widget.recipes.products!.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.col
                              ),
                            ),
                          ),
                        )
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
