import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String title = '';
  String description = '';
  double price = 0.0;
  final GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Type title here'),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should have al least 5 characters';
        }
      },
      onSaved: (String value) {
        setState(() {
          title = value;
        });
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product description'),
      maxLines: 4,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should have at least 10 characters';
        }
      },
      onSaved: (String value) {
        setState(() {
          description = value;
        });
      },
    );
  }

  Widget _buildDescriptionPriceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product price'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }
        if (double.parse(value) < 5) {
          return 'Price should be greater then 5';
        }
      },
      onSaved: (String value) {
        setState(() {
          price = double.parse(value);
        });
      },
    );
  }

  void _submitForm() {
    if (!_globalKey.currentState.validate()) {
      return;
    }
    _globalKey.currentState.save();

    final Map<String, dynamic> product = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': 'assets/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      width: targetWidth,
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _globalKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: <Widget>[
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildDescriptionPriceField(),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: _submitForm,
              child: Container(
                color: Colors.green,
                padding: EdgeInsets.all(5.0),
                child: Text('My Button'),
              ),
            )
            // Text(_value)
          ],
        ),
      ),
    );
  }
}
