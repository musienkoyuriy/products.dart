import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;

  User get authenticatedUser {
    return _authenticatedUser;
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://products-flutter-fb26d.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
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
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject<bool>();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> user = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final String flag =
        authMode == AuthMode.Login ? 'verifyPassword' : 'signupNewUser';

    final http.Response response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/${flag}?key=AIzaSyCv5q-i4iU67doXIvZBs0UQJsMjZOxThrk',
        body: json.encode(user),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('email', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email not found!';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'This password is invalid!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email exists!';
    }

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');

    if (token != null) {
      final DateTime now = DateTime.now();
      final DateTime parsedExpiryTime = DateTime.parse(expiryTimeString);

      if (now.isBefore(parsedExpiryTime)) {
        return;
      }

      final String userEmail = prefs.getString('email');
      final String userId = prefs.getString('userId');
      final tokenLifespan = parsedExpiryTime.difference(now).inSeconds;

      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _userSubject.add(false);
    _authTimer.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.remove('email');
    userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(milliseconds: time * 5), () {
      logout();
      _userSubject.add(false);
    });
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
      final http.Response response = await http.post(
          'https://products-flutter-fb26d.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));
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
            "https://products-flutter-fb26d.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}",
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
            "https://products-flutter-fb26d.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}")
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
