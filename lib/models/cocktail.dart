import 'dart:convert';

class Cocktail {
  String name;
  String? description;
  String? price;

  Cocktail({required this.name, this.description, this.price});


  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "description": description,
      "price": price
    };
  }

  static Cocktail fromJsonMap(Map map) {
    return Cocktail(name: map["name"], description: map["description"], price: map["price"]);
  }

  String toJson() {
    return json.encode({
      "name": name,
      "description": description,
      "price": price
    });
  }

  static Cocktail fromJson(String encodedString) {
    Map map = json.decode(encodedString);
    return fromJsonMap(map);
  }

}