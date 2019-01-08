import 'package:flutter/material.dart';

import '../widgets/products/price_tag.dart';
import '../widgets/products/address_tag.dart';
import '../ui_elements/title_default.dart';

class ProductDetailsPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  final String address;

  ProductDetailsPage(
      this.title, this.description, this.price, this.imageUrl, this.address);

  _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(title),
        SizedBox(width: 5.0),
        PriceTag(price)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print('back');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(imageUrl),
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        _buildPriceRow(),
                        SizedBox(
                          height: 10.0,
                        ),
                        AddressTag(address),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(description)
                      ],
                    ))
              ],
            ))));
  }
}
