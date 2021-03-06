import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import './scoped-models/main.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          // home: AuthPage(),
          routes: {
            '/': (BuildContext context) => ScopedModelDescendant(builder:
                    (BuildContext context, Widget child, MainModel model) {
                  return !_isAuthenticated ? AuthPage() : ProductsPage(_model);
                }),
            '/admin': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductAdmin(_model)
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthPage(),
              );
            }
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final String productId = pathElements[2];
              final Product product =
                  _model.allProducts.firstWhere((Product product) {
                return product.id == productId;
              });
              _model.selectProduct(productId);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductDetailsPage(product),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    _isAuthenticated ? ProductsPage(_model) : AuthPage());
          },
        ));
  }
}
