class Cocktail {
  String name;
  String? description;
  String? price;

  Cocktail({required this.name, this.description, this.price});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price
    };
  }

  static Cocktail fromJson(Map<String, dynamic> map) {
    return Cocktail(name: map["name"], description: map["description"], price: map["price"]);
  }
}