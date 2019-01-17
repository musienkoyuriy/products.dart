import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/product_edit.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildEditButton(BuildContext context, int productIndex, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(productIndex);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            }
          )
        ).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  Widget _buildProducts(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Dismissible(
          key: Key(model.allProducts[index].title),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              model.selectProduct(index);
              model.deleteProduct();
            }
          },
          background: Container(color: Colors.red),
          child: Column(children: <Widget>[
            ListTile(
              title: Text(model.allProducts[index].title),
              leading: CircleAvatar(
                backgroundImage: AssetImage(model.allProducts[index].imageUrl),
              ),
              subtitle: Text('\$${model.allProducts[index].price.toString()}'),
              trailing: _buildEditButton(context, index, model),
            ),
            Divider()
          ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(itemCount: model.allProducts.length, itemBuilder: _buildProducts);
      });
  }
}
