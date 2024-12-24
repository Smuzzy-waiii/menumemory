class Dish {
  String id;
  String name;

  Dish({
    required this.id,
    required this.name
  });

  Map toMap() {
    Map<String, dynamic> res = {};
    res["id"] = id;
    res["name"] = name;

    return res;
  }

  String displayText() {
    String text = "{";
    text += "   id: $id\n";
    text += "   name: $name\n";
    text += "}";
    return text;
  }

  static Dish fromJson(Map<String, dynamic> snapshotData) {
    return Dish(id: snapshotData["id"], name: snapshotData["name"]);
  }
}