import 'package:flutter/material.dart';
import 'package:what2bake/services/api.dart';
import 'package:what2bake/widgets/recipeCard.dart';
import '../data/globalvar.dart' as globals;

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  late int pageNumber;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    pageNumber = 0;
    loadPage();
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

  List<dynamic> data = [];
  List<dynamic> recipes = [];
  List<int> similarity = [];
  List<int> products = [];



  Future loadPage() async {

    data = await getRecipes(pageNumber);
    recipes += data[0];
    similarity += data[1];
    products += data[2];
    products = products.toSet().toList();
    pageNumber++;

    if(mounted) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: CustomScrollView(
        controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 220,
                ),
                delegate: SliverChildBuilderDelegate( (context, index) {

                  int howManyProducts = 0;
                  for(var i = 0; i < products.length; i++) {
                    for(var j = 0; j < recipes[index].products.length; j++) {
                      if(recipes[index].products[j].id == products[i]) howManyProducts += 1;
                    }
                  }

                  Color col;
                  if(similarity[index] == 0) {
                    col = Colors.green;
                  } else if(similarity[index] == recipes[index].products.length) {
                    col = Colors.red;
                  } else {
                    col = Colors.white;
                  }

                  return RecipeCard(recipes[index], howManyProducts, products, col);
                },
                  childCount: recipes.length,

                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 178.5, vertical: 20),
                  child: CircularProgressIndicator()
              ),
            )
          ]
      )
    );
  }
}

