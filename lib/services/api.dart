import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:what2bake/services/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

var client = http.Client();
const apiUrl = "w2b.poneciak.com";

void responseCodes(response) {
  late String message;
  if (response.statusCode == 200) {
    message = "";
  } else if (response.statusCode == 401) {
    // Unauthorized
    message = "Brak autoryzacji";
    print('Unauthorized: Please provide valid credentials.');
  } else if (response.statusCode == 403) {
    // Forbidden
    message = "Nie masz dostępu do tego zasobu";
    print('Forbidden: You do not have access to this resource.');
  } else if (response.statusCode == 404) {
    // Not Found
    message = "Zasób nie został odnaleziony";
    print('Not Found: The requested resource was not found.');
  } else if (response.statusCode == 400) {
    // Bad Request
    message = "Błąd";
    print('Bad Request: The server could not understand the request.');
  } else if (response.statusCode == 429) {
    // Too Many Requests
    message = "Zbyt wiele żądań";
    print('Too Many Requests: Please wait before making more requests.');
  } else if (response.statusCode == 500) {
    // Internal Server Error
    message = "Wewnętrzny błąd serwera";
    print('Internal Server Error: Please try again later.');
  } else {
    // Other non-200 status code
    message = "Akcja nie powiodła się";
    print('Request failed with status: ${response.statusCode}');
  }
  (message != "") ? Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0
  ) : null;
}

Future<dynamic> getAllProducts() async {

  var params = {
    "productOrder": "ALPHABETIC_ASC"
  };
  try {
    //GETALLPRODUCTS
    final uri = Uri.https(apiUrl, '/api/products', params);
    var request = http.Request('GET', uri);
    request.headers['Content-Type'] = 'application/json';

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

    final uri2 = Uri.https(apiUrl, '/api/categories', params);
    var request2 = http.Request('GET', uri2);
    request2.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response2 = await client.send(request2);
    String data2 = await response2.stream.transform(convert.utf8.decoder).join();
    var jsonData2 = convert.jsonDecode(data2);

    List<Category> categories = [];
    for (var res2 in jsonData2) {
      categories.add(Category.fromJson(res2));
    }

    responseCodes(response);

    return [products, pressed, categories];
  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return ["noNetwork"];
  } catch (e) {
    debugPrint(e.toString());
  }
}


Future<dynamic> getRecipesInfo(List<int> tags, sortName, {int rating = 0, int minProducts = 0, int maxProducts = 1000, List<dynamic> mainIngredients = const []}) async {
  final prefs = await SharedPreferences.getInstance();
  var products = prefs.getStringList('0')?.isEmpty == false ? prefs.getStringList('0')!.map(int.parse).toList() : [0];
  List<int> mainIngredientsIds = [];
  for(var x in mainIngredients) {
    mainIngredientsIds.add(x.id);
  }
  Map<String, Object> params = {
    "products": products.join(","),
    "orderList": (sortName == " ") ? "PRODUCTS_PROGRESS_DESC, PRODUCTS_HAS_DESC" : "$sortName, PRODUCTS_PROGRESS_DESC, PRODUCTS_HAS_DESC",
    "tags": tags.join(","),
    "tagOption": (tags == []) ? "STRICT" : "NORMAL",
    //FILTERS
    "minProducts": minProducts.toString(),
    "maxProducts": maxProducts.toString(),
    "rating": rating.toString(),
    "keyProducts": mainIngredientsIds.join(",")
  };
  try {
    final uri = Uri.https(apiUrl, '/api/recipes/info', params);
    var request = http.Request('GET', uri);
    request.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response = await client.send(request);
    String data = await response.stream.transform(convert.utf8.decoder).join();

    responseCodes(response);

    return RecipesInfo.fromJson(convert.jsonDecode(data));

  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );

    return "noNetwork";
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<dynamic> getRecipes(List<int> sharedPrefs, int page, List<int> tags, sortName, {int rating = 0, int minProducts = 0, int maxProducts = 1000, List<dynamic> mainIngredients = const []} ) async {

  List<int> mainIngredientsIds = [];
  for(var x in mainIngredients) {
    mainIngredientsIds.add(x.id);
  }
  Map<String, Object> params = {
    "page": page.toString(),
    "products": sharedPrefs.join(","),
    "orderList": (sortName == " ") ? "PRODUCTS_PROGRESS_DESC, PRODUCTS_HAS_DESC" : "$sortName, PRODUCTS_PROGRESS_DESC, PRODUCTS_HAS_DESC",
    "tags": tags.join(","),
    "tagOption": (tags == []) ? "STRICT" : "NORMAL",
    //FILTERS
    "minProducts": minProducts.toString(),
    "maxProducts": maxProducts.toString(),
    "rating": rating.toString(),
    "keyProducts": mainIngredientsIds.join(",")
  };

  try {
    //GETALLRECIPES
    final uri = Uri.https(apiUrl, '/api/recipes', params);
    var request = http.Request('GET', uri);
    request.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response = await client.send(request);
    String data = await response.stream.transform(convert.utf8.decoder).join();
    var jsonData = convert.jsonDecode(data);

    List<Recipe> recipes = [];
    List similarity = [];
    for (var res in jsonData) {
      var temp = Recipe.fromJson(res);
      var similarityNumber = 0;
      for (var i = 0; i < temp.products!.length; i++) {
        if (sharedPrefs.contains(temp.products![i].id)) {
          similarityNumber++;
        }
      }
      recipes.add(temp);


      similarity.add(similarityNumber);
    }

    //GET ALL RECIPE FAVORITE IDS IF USER IS LOGGED IN
    List<String> favoritesId = [];
    if(globals.isLogged) {
      final uri = Uri.https(apiUrl, '/api/likes/id', params);
      var request = http.Request('GET', uri);
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${globals.pb.authStore.token}';
      request.headers['Content-Type'] = 'application/json';

      http.StreamedResponse response = await client.send(request);
      String data = await response.stream.transform(convert.utf8.decoder).join();
      data = data.substring(1, data.length - 1);
      favoritesId = data.split(',');

      //PLACE FOR GETTING LIST OF RATED RECIPES

    }

    responseCodes(response);

    return [recipes, similarity, sharedPrefs, favoritesId];
  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return ["noNetwork"];
  } catch (e) {
    debugPrint(e.toString());
  }


}

Future<dynamic> getFavorites(int page) async {
  final prefs = await SharedPreferences.getInstance();
  var products = prefs.getStringList('0')?.isEmpty == false ? prefs.getStringList('0')!.map(int.parse).toList() : [0];
  Map<String, Object> params = {
    "page": page.toString(),
  };

  try {

    //GETALLFAVORITES

    final uri = Uri.https(apiUrl, '/api/likes', params);
    var request = http.Request('GET', uri);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${globals.pb.authStore.token}';
    request.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response = await client.send(request);
    String data = await response.stream.transform(convert.utf8.decoder).join();
    var jsonData = convert.jsonDecode(data);

    List<Recipe> recipes = [];
    List similarity = [];
    for (var res in jsonData) {
      var temp = Recipe.fromJson(res);
      var similarityNumber = 0;
      for (var i = 0; i < temp.products!.length; i++) {
        if (products.contains(temp.products![i].id)) {
          similarityNumber++;
        }
      }
      recipes.add(temp);

      similarity.add(similarityNumber);
    }

    List<String> favoritesId = [];
    final uri2 = Uri.https(apiUrl, '/api/likes/id');
    var request2 = http.Request('GET', uri2);
    request2.headers[HttpHeaders.authorizationHeader] = 'Bearer ${globals.pb.authStore.token}';
    request2.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response2 = await client.send(request2);
    String data2 = await response2.stream.transform(convert.utf8.decoder).join();
    data2 = data2.substring(1, data2.length - 1);
    favoritesId = data2.split(',');

    responseCodes(response);

    return [recipes, similarity, products, favoritesId]; //Przerobic na obiekt
  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return ["noNetwork"];
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<dynamic> getAllTags() async {
  try {
    //GETALLTAGS

    final uri = Uri.https(apiUrl, '/api/tags');
    var request = http.Request('GET', uri);
    request.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response = await client.send(request);
    String data = await response.stream.transform(convert.utf8.decoder).join();
    var jsonData = convert.jsonDecode(data);

    List<Tag> tags = [];
    for (var res in jsonData) {
      tags.add(Tag.fromJson(res));
    }

    responseCodes(response);

    return tags;
  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return ["noNetwork"];
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> changeFavoriteRecipeStatus(String httpMethod, String recipeId) async {
  try {
    final uri = Uri.https(apiUrl, '/api/likes/$recipeId');
    var request = http.Request(httpMethod, uri);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${globals.pb.authStore.token}';
    request.headers['Content-Type'] = 'application/json';
    await client.send(request);

  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> changeRating(String httpMethod, int number, String recipeId) async {
  try {
    Map<String, Object> body = {
      "stars": number.toString()
    };
    var request = http.Request(httpMethod, Uri.parse('https://$apiUrl/api/recipes/ratings/$recipeId'));
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${globals.pb.authStore.token}';
    request.headers['Content-Type'] = 'application/json';
    if(httpMethod != "DELETE") request.body = convert.jsonEncode(body);
    await client.send(request);
  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<dynamic> getAllRatingsId() async {
  try {

    final uri = Uri.https(apiUrl, '/api/recipes/ratings/id');
    var request = http.Request('GET', uri);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${globals.pb.authStore.token}';
    request.headers['Content-Type'] = 'application/json';

    http.StreamedResponse response = await client.send(request);

    String data = await response.stream.transform(convert.utf8.decoder).join();
    final Map<String, dynamic> jsonData = convert.jsonDecode(data);

    responseCodes(response);

    return jsonData;
  } on SocketException {
    Fluttertoast.showToast(
        msg: 'Błąd sieci: Sprawdź swoje połączenie internetowe.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}