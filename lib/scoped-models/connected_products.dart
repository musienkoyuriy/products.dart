import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;
  final String API_URL =
      "https://products-flutter-fb26d.firebaseio.com/products.json";
  bool _isLoading = false;

  User get authenticatedUser {
    return _authenticatedUser;
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get(API_URL).then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
        );

        fetchedProductList.add(product);
        _isLoading = false;
        notifyListeners();
      });
      _products = fetchedProductList;
    });
  }

  Future<Null> addProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'imageUrl':
          'https://www.hoax-slayer.net/wp-content/uploads/2018/08/chocolate-blocks-140818-1.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .post(API_URL, body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData['id']);
      final Product product = Product(
          id: responseData['id'],
          title: title,
          description: description,
          imageUrl: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(product);
      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '1231', email: email, password: password);
    print(_authenticatedUser);
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  bool get isFavoriteMode {
    return _showFavorites;
  }

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get favorites {
    return _products
        .where((Product product) => product.favorite == true)
        .toList();
  }

  List<Product> get displayedProducts {
    return _showFavorites ? favorites : allProducts;
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    return _selectedProductIndex == null
        ? null
        : _products[selectedProductIndex];
  }

  Future<Null> updateProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    final Map<String, dynamic> productData = {
      'id': selectedProduct.id,
      'title': title,
      'description': description,
      'imageUrl': image,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            "https://products-flutter-fb26d.firebaseio.com/products/${selectedProduct.id}.json",
            body: json.encode(productData))
        .then((http.Response response) {
      _isLoading = false;
      // final Map<String, dynamic> productData
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          imageUrl: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selectedProductIndex = null;
    http
        .delete(
            "https://products-flutter-fb26d.firebaseio.com/products/${deletedProductId}.json")
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    if (_selectedProductIndex != null) {
      notifyListeners();
    }
  }

  void toggleProductFavorite() {
    final bool isFavorite = selectedProduct.favorite;
    final bool newFavoriteStatus = !isFavorite;
    final updatedProduct = Product(
        description: selectedProduct.description,
        title: selectedProduct.title,
        price: selectedProduct.price,
        imageUrl: selectedProduct.imageUrl,
        favorite: newFavoriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[_selectedProductIndex] = updatedProduct;

    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
