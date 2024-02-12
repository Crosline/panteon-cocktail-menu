class BarSettings {
  String title;
  bool isOpen;

  BarSettings({
    required this.title,
    required this.isOpen
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "isOpen": isOpen
    };
  }

  static BarSettings fromJson(Map<String, dynamic> map) {
    return BarSettings(title: map["title"], isOpen: map["isOpen"]);
  }

  static BarSettings getDefaultSettings() {
    return BarSettings(title: "CBO Panteon Cocktail", isOpen: true);
  }
}