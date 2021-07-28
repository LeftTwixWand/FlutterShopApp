import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;

  const OrderItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd.mm.yyyy hh:mm').format(order.dateTime),
            ),
            trailing:
                IconButton(onPressed: () {}, icon: Icon(Icons.expand_more)),
          ),
        ],
      ),
    );
  }
}
