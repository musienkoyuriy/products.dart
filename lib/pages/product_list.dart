import 'package:flutter/material.dart';
import '../pages/product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;

  ProductListPage(this.products, this.updateProduct);

  Widget _buildProducts(BuildContext context, int index) {
    return ListTile(
      title: Text(products[index]['title']),
      leading: Container(
        child: Image.asset(products[index]['imageUrl']),
        width: 40,
        height: 40
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage(product: products[index], updateProduct: updateProduct, productIndex: index);
            }
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length, itemBuilder: _buildProducts);
  }
}
