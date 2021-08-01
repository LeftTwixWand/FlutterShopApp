import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  var _items = new Map<String, CartItemModel>();

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount {
    return items.length;
  }

  void addItem(String productId, title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItemModel(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemModel(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach(
      (key, value) {
        total += value.price * value.quantity;
      },
    );
    return total;
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (value) => CartItemModel(
            id: value.id,
            title: value.title,
            quantity: value.quantity - 1,
            price: value.price),
      );
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
