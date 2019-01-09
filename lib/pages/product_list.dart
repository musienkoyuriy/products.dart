import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/product_edit.dart';
import '../models/product.dart';
import '../scoped-models/products.dart';

class ProductListPage extends StatelessWidget {
  // final List<Product> products;
  // final Function updateProduct;
  // final Function deleteProduct;

  // ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildEditButton(
      BuildContext context, int productIndex, ProductsModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ProductEditPage(
              product: model.getProduct(productIndex),
              updateProduct: model.updateProduct,
              productIndex: productIndex);
        }));
      },
    );
  }

  Widget _buildProducts(BuildContext context, int index) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return Dismissible(
          key: Key(model.products[index].title),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              model.deleteProduct(index);
            }
          },
          background: Container(color: Colors.red),
          child: Column(children: <Widget>[
            ListTile(
              title: Text(model.products[index].title),
              leading: CircleAvatar(
                backgroundImage: AssetImage(model.products[index].imageUrl),
              ),
              subtitle: Text('\$${model.products[index].price.toString()}'),
              trailing: _buildEditButton(context, index, model),
            ),
            Divider()
          ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return ListView.builder(itemCount: model.products.length, itemBuilder: _buildProducts);
      });
  }
}
