import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../products/price_tag.dart';
import '../../ui_elements/title_default.dart';
import '../../scoped-models/main.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final int productIndex;

  ProductCard(this.productIndex);

  void _goToDetails(BuildContext context) {
    Navigator.pushNamed<bool>(context, '/product/' + productIndex.toString());
  }

  Container _buildTitlePriceRow(Product product) {
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

  bool isProductStarred(MainModel model) {
    return model.allProducts[productIndex].favorite == true;
  }

  ButtonBar _buildActionButtons(BuildContext context, MainModel model) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(Icons.info),
        color: Theme.of(context).accentColor,
        onPressed: () {
          _goToDetails(context);
        }
      ),
      IconButton(
        icon: isProductStarred(model) ? Icon(Icons.star) : Icon(Icons.star_border),
        color: Colors.red,
        onPressed: () {
          model.selectProduct(productIndex);
          model.toggleProductFavorite();
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Card(
          child: Column(children: <Widget>[
            Image.asset(model.allProducts[productIndex].imageUrl),
            _buildTitlePriceRow(model.allProducts[productIndex]),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                child: Text('United States, NY'),
              ),
            ),
            Text(model.allProducts[productIndex].userEmail),
            _buildActionButtons(context, model)
          ])
        );
      }
    );
  }
}
