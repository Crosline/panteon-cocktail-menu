import 'dart:convert';

class Cocktail {
  String name;
  String? description;
  bool? isEnabled;
  String? recipe;

  Cocktail({required this.name, this.description, this.recipe, this.isEnabled});


  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "description": description,
      "recipe": recipe,
      "isEnabled": isEnabled,
    };
  }

  static Cocktail fromJsonMap(Map map) {
    return Cocktail(name: map["name"], description: map["description"], recipe: map["recipe"], isEnabled: map["isEnabled"] );
  }

  String toJson() {
    return json.encode(toJsonMap());
  }

  static Cocktail fromJson(String encodedString) {
    Map map = json.decode(encodedString);
    return fromJsonMap(map);
  }

}