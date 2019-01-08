import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductEditPage({this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'imageUrl': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Type title here'),
      initialValue: widget.product != null ? widget.product['title'] : '',
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should have al least 5 characters';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product description'),
      initialValue: widget.product != null ? widget.product['description'] : '',
      maxLines: 4,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should have at least 10 characters';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildDescriptionPriceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product price'),
      initialValue:
          widget.product != null ? widget.product['price'].toString() : '',
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number';
        }
        if (double.parse(value) < 5) {
          return 'Price should be greater then 5';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  void _submitForm() {
    if (!_globalKey.currentState.validate()) {
      return;
    }

    _globalKey.currentState.save();

    final Map<String, dynamic> product = {
      'title': _formData['title'],
      'description': _formData['description'],
      'price': _formData['price'],
      'imageUrl': 'assets/food.jpg'
    };

    if (widget.product == null) {
      widget.addProduct(product);  
    } else {
      widget.updateProduct(widget.productIndex, widget.product);
    }

    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    final pageContent = GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
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
                RaisedButton(
                  onPressed: _submitForm,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(5.0),
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ));

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit product'),
            ),
            body: pageContent,
          );
  }
}
