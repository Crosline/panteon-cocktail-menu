import 'cocktail.dart';

class Order {
  late Map<Cocktail, int>? cocktails;
  late DateTime? orderTime;
  String accountName;


  Order({required this.accountName, this.orderTime, this.cocktails});

  Map<String, dynamic> toJson() {
    return {
      "cocktails": _serializeCocktailMap(cocktails),
      "orderTime": orderTime!.millisecondsSinceEpoch,
      "account": accountName
    };
  }

  static Map<dynamic, dynamic> _serializeCocktailMap(Map<Cocktail, int>? cocktails) {
    Map<dynamic, dynamic> cocktailMap = <dynamic, dynamic>{};
    if (cocktails == null) return cocktailMap;

    for (Cocktail cocktail in cocktails.keys) {
      cocktailMap[cocktail.toJson()] = cocktails[cocktail];
    }

    return cocktailMap;
  }

  static Map<Cocktail, int> _deserializeCocktailMap(Map<dynamic, dynamic>? cocktails) {
    Map<Cocktail, int> cocktailMap = <Cocktail, int>{};
    if (cocktails == null) return cocktailMap;

    for (Map<String, dynamic> cocktail in cocktails.keys) {
      cocktailMap[Cocktail.fromJson(cocktail)] = cocktails[cocktail];
    }

    return cocktailMap;
  }

  static Order fromJson(Map<String, dynamic> map) {
    var order = Order(
      accountName: map["account"],
      orderTime: DateTime.fromMillisecondsSinceEpoch(map["orderTime"]),
      cocktails: _deserializeCocktailMap(map["cocktails"])
    );

    return order;
  }
}