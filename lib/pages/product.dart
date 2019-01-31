import 'package:flutter/material.dart';
import '../models/product.dart';

import '../widgets/products/price_tag.dart';
import '../widgets/products/address_tag.dart';
import '../ui_elements/title_default.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage(this.product);

  _buildPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(product.title),
        SizedBox(width: 5.0),
        PriceTag(product.price)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeInImage(
                    placeholder: AssetImage("assets/bg.jpg"),
                    height: 300.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(product.imageUrl)),
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        _buildPriceRow(product),
                        SizedBox(
                          height: 10.0,
                        ),
                        AddressTag('NY'),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(product.description)
                      ],
                    ))
              ],
            ))));
  }
}
