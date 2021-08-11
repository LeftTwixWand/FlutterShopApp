import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawr.dart';
import '../widgets/order_item.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFetching;

  Future _obtainOrders() {
    return Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndsetOrders();
  }

  @override
  void initState() {
    _ordersFetching = _obtainOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured!'),
              );
            } else {
              return Consumer<OrdersProvider>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, index) =>
                      OrderItem(order: orderData.orders[index]),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
        future: _ordersFetching,
      ),
      drawer: AppDrawer(),
    );
  }
}
