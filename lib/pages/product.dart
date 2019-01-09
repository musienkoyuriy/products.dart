import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/products.dart';
import '../models/product.dart';

import '../widgets/products/price_tag.dart';
import '../widgets/products/address_tag.dart';
import '../ui_elements/title_default.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productIndex;

  ProductDetailsPage(this.productIndex);

  _buildPriceRow(Product product) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(width: 5.0),
          PriceTag(product.price)
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      print('back');
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return Scaffold(
            appBar: AppBar(title: Text(model.getProduct(productIndex).title)),
            body: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(model.getProduct(productIndex).imageUrl),
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        _buildPriceRow(model.getProduct(productIndex)),
                        SizedBox(
                          height: 10.0,
                        ),
                        AddressTag('NY'),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(model.getProduct(productIndex).description)
                      ],
                    ))
              ],
            )));
      },
    ));
  }
}
