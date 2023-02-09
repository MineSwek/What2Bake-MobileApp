import 'package:flutter/material.dart';
import 'package:what2bake/services/api.dart';
import 'package:what2bake/services/model.dart';
import 'package:what2bake/widgets/ingredientCard.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({super.key});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class Products {
  int? id;
  List<Product> temp1 = [];
  List<String> temp2 = [];

}

class _IngredientsState extends State<Ingredients> {

  List<dynamic> productsApi = [];
  List<dynamic> categories = [];
  List<String> pressed = [];
  late Future _allproducts;

  @override
  void initState() {
    _allproducts = getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: FutureBuilder<dynamic>(
        future: _allproducts,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          Widget newListSliver;
          if(snapshot.hasData) {
            productsApi = snapshot.data[0];
            categories = snapshot.data[2];
            pressed = snapshot.data[1];

            categories.sort((a, b) => a.id.compareTo(b.id));
            List<Products> products = [];
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


            newListSliver =  SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 310

                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: IngredientCard(products: products[index].temp1, pressed: pressed, pressedNumber: products[index].temp2.length),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            );
          } else {
            newListSliver = SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  childCount: 1,
                ),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              newListSliver
            ],
          );
        }
      ),
    );
  }
}
