import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import './product_provider.dart';

class ProductsProvider with ChangeNotifier {
  String _userId = '';
  String _authToken = '';
  List<ProductProvider> _items = [];

  ProductsProvider update(
      String authToken, String userId, List<ProductProvider> items) {
    _authToken = authToken;
    _userId = userId;
    _items = items;
    return this;
  }

  String get authToken => _authToken;

  List<ProductProvider> get items => [..._items];

  List<ProductProvider> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  ProductProvider findById(String id) =>
      _items.firstWhere((element) => element.id == id);

  Future<void> addProduct(ProductProvider product) async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': _userId,
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

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : "";

    var url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductProvider> loadedProducts = [];

      url = Uri.parse(
          'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$_userId.json?auth=$authToken');

      final favoritesResponse = await http.get(url);
      final favoriteData =
          json.decode(favoritesResponse.body) as Map<String, dynamic>?;

      extractedData.forEach((key, value) {
        loadedProducts.add(
          ProductProvider(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[key] ?? false,
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

  Future<void> updateProduct(String id, ProductProvider newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex < 0) return;

    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');

    await http.patch(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-update-973d5-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    ProductProvider existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);

      notifyListeners();

      throw HttpException('Could not delete product.');
    }

    existingProduct.dispose();
  }
}
