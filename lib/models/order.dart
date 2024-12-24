import 'dish.dart';

class VisitOrder {
  Dish dish;
  double rating;
  String? review_text;

  VisitOrder({required this.dish, required this.rating, this.review_text});

  Map toMap() {
    Map<String, dynamic> res = {};
    res["dish"] = dish.toMap();
    res["rating"] = rating;
    res["review_text"] = review_text;

    return res;
  }

  String displayText() {
    String text = "{";
    text += "   dish: ${dish.displayText()}\n";
    text += "   rating: $rating\n";
    text += "   review_text: $review_text\n";
    text += "}";
    return text;
  }

  static VisitOrder fromJson(Map<String, dynamic> snapshotData) {
    Dish _dish = Dish.fromJson(snapshotData["dish"]);
    return VisitOrder(dish: _dish, rating: snapshotData["rating"], review_text: snapshotData["review_text"]);
  }
}