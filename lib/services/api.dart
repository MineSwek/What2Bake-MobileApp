import 'package:what2bake/services/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

var client = http.Client();
const apiUrl = "http://api.what2bake.com";

Future<dynamic> getAllProducts() async {

  var body = {
    "productOrder": ["ALPHABETIC_ASC"]
  };
  try {

    //GETALLPRODUCTS

    var request = http.Request('GET', Uri.parse("$apiUrl/product/"));
    request.headers['Content-Type'] = 'application/json';
    request.body = convert.jsonEncode(body);

    http.StreamedResponse response = await client.send(request);
    String data = await response.stream.transform(convert.utf8.decoder).join();
    var jsonData = convert.jsonDecode(data);

    final prefs = await SharedPreferences.getInstance();
    var pressed = prefs.getStringList('0') ?? [];

    List<Product> products = [];
    for (var res in jsonData) {
      products.add(Product.fromJson(res));
    }

    //GETALLCATEGORIES

    var request2 = http.Request('GET', Uri.parse("$apiUrl/category/"));
    request2.headers['Content-Type'] = 'application/json';
    request2.body = convert.jsonEncode(body);

    http.StreamedResponse response2 = await client.send(request2);
    String data2 = await response2.stream.transform(convert.utf8.decoder).join();
    var jsonData2 = convert.jsonDecode(data2);

    List<Category> categories = [];
    for (var res2 in jsonData2) {
      categories.add(Category.fromJson(res2));
    }

    return [products, pressed, categories];
  } catch (e) {
    print(e);
  }

}

Future<dynamic> getRecipes(int page) async {
  final prefs = await SharedPreferences.getInstance();
  var products = prefs.getStringList('0')?.isEmpty == false ? prefs.getStringList('0')!.map(int.parse).toList() : [0];

  Map<String, Object> body;
  if(products == [0]) {
    body = {
      "page": page,
      "products": products,
    };
  } else {
    body = {
      "page": page,
      "products": products,
      "productOrder": ["PROGRESS_DESC", "HAS_DESC"]
    };
  }

  try {

    //GETALLRECIPES
    var request = http.Request('GET', Uri.parse("$apiUrl/recipe/"));
    request.headers['Content-Type'] = 'application/json';
    request.body = convert.jsonEncode(body);

    http.StreamedResponse response = await client.send(request);
    String data = await response.stream.transform(convert.utf8.decoder).join();
    var jsonData = convert.jsonDecode(data);

    List recipes = [];
    List<int> similarity = [];
    for (var res in jsonData) {
      var temp = Recipe.fromJson(res);
      var temp2 = 0;
      for (var i = 0; i < temp.products!.length; i++) {
        if (products.contains(temp.products![i].id)) {
          temp2++;
        }
      }
      recipes.add(temp);
      similarity.add((temp2 - temp.products!.length).abs());
    }

    return [recipes, similarity, products];
  } catch (e) {
    print(e);
  }


}