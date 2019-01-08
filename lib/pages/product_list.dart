import 'package:flutter/material.dart';
import '../pages/product_edit.dart';
import '../models/product.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function updateProduct;
  final Function deleteProduct;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildEditButton(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ProductEditPage(
              product: products[index],
              updateProduct: updateProduct,
              productIndex: index);
        }));
      },
    );
  }

  Widget _buildProducts(BuildContext context, int index) {
    return Dismissible(
        key: Key(products[index].title),
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.endToStart) {
            deleteProduct(index);
          }
        },
        background: Container(color: Colors.red),
        child: Column(children: <Widget>[
          ListTile(
            title: Text(products[index].title),
            leading: CircleAvatar(
              backgroundImage: AssetImage(products[index].imageUrl),
            ),
            subtitle: Text('\$${products[index].price.toString()}'),
            trailing: _buildEditButton(context, index),
          ),
          Divider()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length, itemBuilder: _buildProducts);
  }
}
