import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/orders.json');

    final timeStamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'total': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (item) => {
                  'id': item.id,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                },
              )
              .toList()
        },
      ),
    );

    _orders.insert(
      0,
      OrderModel(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );

    notifyListeners();
  }
}
