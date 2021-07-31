import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawr.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, index) => Column(
            children: [
              UserProductItem(
                title: productsProvider.items[index].title,
                imageUrl: productsProvider.items[index].imageUrl,
              ),
              Divider(),
            ],
          ),
          itemCount: productsProvider.items.length,
        ),
      ),
    );
  }
}
