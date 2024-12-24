import 'dart:ffi';

class Restaurant {
  String id;
  String name;
  String area;
  String address;
  String? mapsLink;
  double? mapsRatingOutOf5;

  Restaurant({
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    this.mapsLink,
    this.mapsRatingOutOf5
  });

  Map toMap() {
    Map<String, dynamic> res = {};
    res["id"] = this.id;
    res["name"] = this.name;
    res["area"] = this.area;
    res["address"] = this.address;
    res["mapsLink"] = this.mapsLink ?? "";
    res["mapsRatingOutOf5"] = this.mapsRatingOutOf5 ?? "";

    return res;
  }

  String displayText() {
    String text = "{";
    text += "   id: $id\n";
    text += "   name: $name\n";
    text += "   area: $area\n";
    text += "   address: $address\n";
    text += "   mapsLink: $mapsLink\n";
    text += "   mapsRatingOutOf5: $mapsRatingOutOf5\n";
    text += "}";
    return text;
  }
}