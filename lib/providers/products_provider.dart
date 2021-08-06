import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [];

  List<ProductProvider> get items => [..._items];

  List<ProductProvider> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  ProductProvider findById(String id) =>
      _items.firstWhere((element) => element.id == id);

  Future<void> addProduct(ProductProvider product) async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final newProduct = ProductProvider(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProduct() async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductProvider> loadedProducts = [];

      extractedData.forEach((key, value) {
        loadedProducts.add(
          ProductProvider(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void updateProduct(String id, ProductProvider newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex < 0) return;

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
