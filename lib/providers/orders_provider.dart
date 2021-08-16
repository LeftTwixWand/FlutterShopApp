import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrdersProvider with ChangeNotifier {
  String _authToken = '';

  List<OrderModel> _orders = [];

  OrdersProvider update(String authToken, List<OrderModel> orders) {
    _authToken = authToken;
    _orders = orders;

    return this;
  }

  List<OrderModel> get orders => [..._orders];

  Future<void> fetchAndsetOrders() async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$_authToken');

    final response = await http.get(url);
    final List<OrderModel> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    extractedData?.forEach((key, value) {
      loadedOrders.add(
        OrderModel(
          id: key,
          amount: value['total'],
          products: (value['products'] as List<dynamic>)
              .map(
                (item) => CartItemModel(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(value['dateTime']),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$_authToken');

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
