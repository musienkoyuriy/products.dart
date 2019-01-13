import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

mixin ProductsModel on Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavorites = false;

  bool get isFavoriteMode {
    return _showFavorites;
  }

  List<Product> get products {
    return List.from(_products);
  }

  List<Product> get favorites {
    return products.where((Product product) => product.favorite == true).toList();
  }

  List<Product> get displayedProducts {
    return _showFavorites ? products : favorites;
  }

  Product get getProduct {
    return _selectedProductIndex == null
        ? null
        : _products[_selectedProductIndex];
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }

  void toggleProductFavorite() {
    final bool isFavorite = getProduct.favorite;
    final bool newFavoriteStatus = !isFavorite;
    final updatedProduct = Product(
      description: getProduct.description,
      title: getProduct.title,
      price: getProduct.price,
      imageUrl: getProduct.imageUrl,
      favorite: newFavoriteStatus
    );
    _products[_selectedProductIndex] = updatedProduct;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
    _selectedProductIndex = null;
  }
}
