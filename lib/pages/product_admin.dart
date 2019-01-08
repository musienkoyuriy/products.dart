import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';

class ProductAdmin extends StatelessWidget {
  final Function addProduct;
  final Function updateProduct;
  final List<Map<String, dynamic>> products;

  ProductAdmin(this.addProduct, this.updateProduct, this.products);

  _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Back to products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: _buildSideDrawer(context),
            appBar: AppBar(
                title: Text('Product Admin'),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.create), text: 'Create Product'),
                    Tab(icon: Icon(Icons.list), text: 'My Products')
                  ],
                )),
            body: TabBarView(
              children: <Widget>[
                ProductEditPage(addProduct: addProduct, updateProduct: updateProduct),
                ProductListPage(products, updateProduct),
              ],
            )));
  }
}