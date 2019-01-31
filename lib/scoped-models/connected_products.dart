import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  final String API_URL =
      "https://products-flutter-fb26d.firebaseio.com/products.json";
  bool _isLoading = false;

  User get authenticatedUser {
    return _authenticatedUser;
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get(API_URL).then<Null>((http.Response response) {
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
      });
      _isLoading = false;
      notifyListeners();
      _products = fetchedProductList;
      _selectedProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '1231', email: email, password: password);
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    final Map<String, dynamic> user = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCv5q-i4iU67doXIvZBs0UQJsMjZOxThrk',
        body: json.encode(user),
        headers: {
          'Content-Type': 'application/json'
        });

    return {'success': true, 'message': 'Auth succeeded!'};

  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  bool get isFavoriteMode {
    return _showFavorites;
  }

  int get selectedProductIndex {
    return _products
        .indexWhere((Product product) => product.id == _selectedProductId);
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

  String get selectedProductId {
    return _selectedProductId;
  }

  Product get selectedProduct {
    return _selectedProductId == null
        ? null
        : _products
            .firstWhere((Product product) => product.id == _selectedProductId);
  }

  Future<bool> addProduct(
      String title, String description, double price, String image) async {
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
    try {
      final http.Response response =
          await http.post(API_URL, body: json.encode(productData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
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
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
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
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selectedProductId = null;
    http
        .delete(
            "https://products-flutter-fb26d.firebaseio.com/products/${deletedProductId}.json")
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String productId) {
    _selectedProductId = productId;
    if (_selectedProductId != null) {
      notifyListeners();
    }
  }

  void toggleProductFavorite() {
    final bool isFavorite = selectedProduct.favorite;
    final bool newFavoriteStatus = !isFavorite;
    final updatedProduct = Product(
        id: selectedProduct.id,
        description: selectedProduct.description,
        title: selectedProduct.title,
        price: selectedProduct.price,
        imageUrl: selectedProduct.imageUrl,
        favorite: newFavoriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;

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
