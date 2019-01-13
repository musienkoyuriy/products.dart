import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../products/product_card.dart';
import '../../scoped-models/main.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCard = Center(child: Text('There are no products yet'));

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(index);
        },
        itemCount: products.length,
      );
    }

    return productCard;
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}
