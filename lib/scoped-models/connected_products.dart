import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;

  User get authenticatedUser {
    return _authenticatedUser;
  }

  void addProduct(
      String title, String description, double price, String image) {
    print(authenticatedUser);
    final Product product = Product(
        title: title,
        description: description,
        imageUrl: image,
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    _products.add(product);
    notifyListeners();
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

  void updateProduct(
      String title, String description, double price, String image) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        imageUrl: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    notifyListeners();
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
