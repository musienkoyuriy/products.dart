import 'package:flutter/material.dart';
import '../products/price_tag.dart';
import '../../ui_elements/title_default.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  void _goToDetails(BuildContext context) {
    Navigator.pushNamed<bool>(context, '/product/' + productIndex.toString());
  }

  Container _buildTitlePriceRow() {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(
              width: 10.0,
            ),
            PriceTag(product.price)
          ],
        ),
        margin: EdgeInsets.only(top: 10.0));
  }

  ButtonBar _buildActionButtons(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).accentColor,
          onPressed: () {
            _goToDetails(context);
          }),
      IconButton(
        icon: Icon(Icons.favorite_border),
        color: Colors.red,
        onPressed: () {},
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset(product.imageUrl),
      _buildTitlePriceRow(),
      DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
          child: Text('United States, NY'),
        ),
      ),
      _buildActionButtons(context)
    ]));
  }
}
