import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import '../scoped-models/products.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Product product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

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
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Type title here'),
          initialValue: widget.product != null ? widget.product.title : '',
          validator: (String value) {
            if (value.isEmpty || value.length < 5) {
              return 'Title is required and should have al least 5 characters';
            }
          },
          onSaved: (String value) {
            _formData['title'] = value;
          },
        ));
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product description'),
          initialValue:
              widget.product != null ? widget.product.description : '',
          maxLines: 4,
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return 'Description is required and should have at least 10 characters';
            }
          },
          onSaved: (String value) {
            _formData['description'] = value;
          },
        ));
  }

  Widget _buildDescriptionPriceField() {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
          focusNode: _priceFocusNode,
          decoration: InputDecoration(labelText: 'Product price'),
          initialValue:
              widget.product != null ? widget.product.price.toString() : '',
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
        ));
  }

  void _submitForm(Function addProduct, Function updateProduct) {
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
      addProduct(Product(
          title: _formData['title'],
          description: _formData['description'],
          price: _formData['price'],
          imageUrl: _formData['imageUrl']));
    } else {
      updateProduct(
          widget.productIndex,
          Product(
              title: _formData['title'],
              description: _formData['description'],
              price: _formData['price'],
              imageUrl: _formData['imageUrl']));
    }

    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return RaisedButton(
        onPressed: () => _submitForm(model.addProduct, model.updateProduct),
        textColor: Colors.white,
        padding: EdgeInsets.all(5.0),
        child: Text('Save'),
      );
    });
  }

  Widget _buildPageContent(double width, double padding) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: width,
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _globalKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: padding / 2),
              children: <Widget>[
                _buildTitleTextField(),
                _buildDescriptionTextField(),
                _buildDescriptionPriceField(),
                SizedBox(height: 10.0),
                _buildSubmitButton()
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    final pageContent = _buildPageContent(targetWidth, targetPadding);

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
