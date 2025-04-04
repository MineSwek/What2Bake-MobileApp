class Recipe {
  String? title;
  String? image;
  String? link;
  double? rating;
  int? rating_count;
  String? idRec;
  List<Product>? products;

  Recipe({this.title, this.image, this.link, this.products, this.rating, this.idRec, this.rating_count});

  Recipe.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    link = json['link'];
    rating = json['rating'];
    rating_count = json['rating_count'];
    idRec = json['id'].toString();
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

}

class Product {
  late int id;
  late String name;
  Category? category;
  Product({required this.id, required this.name, this.category});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
  }

}

class Category {
  int? id;
  String? name;
  String? icon;

  Category({this.id, this.name, this.icon});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }
}

class Tag {
  int? id;
  String? name;

  Tag(this.id, this.name);

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class RecipesInfo {
  int? count;
  int? countWithFilters;

  RecipesInfo({this.count, this.countWithFilters});

  RecipesInfo.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    countWithFilters = json['countWithFilters'];
  }

}