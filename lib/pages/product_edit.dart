import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/helpers/ensure-visible.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
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

  Widget _buildTitleTextField(Product selectedPoduct) {
    return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Type title here'),
          initialValue: selectedPoduct != null ? selectedPoduct.title : '',
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

  Widget _buildDescriptionTextField(Product selectedProduct) {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          focusNode: _descriptionFocusNode,
          decoration: InputDecoration(labelText: 'Product description'),
          initialValue:
              selectedProduct != null ? selectedProduct.description : '',
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

  Widget _buildDescriptionPriceField(Product selectedProduct) {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
          focusNode: _priceFocusNode,
          decoration: InputDecoration(labelText: 'Product price'),
          initialValue:
              selectedProduct != null ? selectedProduct.price.toString() : '',
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

  void _submitForm(MainModel model) {
    if (!_globalKey.currentState.validate()) {
      return;
    }

    _globalKey.currentState.save();

    if (model.selectedProductIndex == null) {
      model
          .addProduct(_formData['title'], _formData['description'],
              _formData['price'], _formData['imageUrl'])
          .then((_) {
        Navigator.pushReplacementNamed(context, '/products')
            .then((_) => model.selectProduct(null));
      });
    } else {
      model
          .updateProduct(_formData['title'], _formData['description'],
              _formData['price'], _formData['imageUrl'])
          .then((_) {
        Navigator.pushReplacementNamed(context, '/products')
            .then((_) => model.selectProduct(null));
      });
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              onPressed: () => _submitForm(model),
              textColor: Colors.white,
              padding: EdgeInsets.all(5.0),
              child: Text('Save'),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product selectedProduct) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
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
                _buildTitleTextField(selectedProduct),
                _buildDescriptionTextField(selectedProduct),
                _buildDescriptionPriceField(selectedProduct),
                SizedBox(height: 10.0),
                _buildSubmitButton()
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);

      return model.selectedProductIndex == null
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit product'),
              ),
              body: pageContent,
            );
    });
  }
}
