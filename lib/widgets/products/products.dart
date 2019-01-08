import 'package:flutter/material.dart';
import '../products/product_card.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  final List<Product> products;

  Products(this.products) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductWidget(BuildContext context, int index) {
    return ProductCard(products[index], index);
  }

  Widget _buildProductList() {
    Widget productCard = Center(child: Text('There are no products yet'));

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductWidget,
        itemCount: products.length,
      );
    }

    return productCard;
  }

  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
