import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../products/product_card.dart';
import '../../scoped-models/products.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCard = Center(child: Text('There are no products yet'));

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(products[index], index);
        },
        itemCount: products.length,
      );
    }

    return productCard;
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return _buildProductList(model.products);
    });
  }
}
