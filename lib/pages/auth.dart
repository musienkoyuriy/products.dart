import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  bool _termsAccepted = false;
  RegExp emailRegexp = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  final Map<String, String> _formState = {'email': null, 'password': null};
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/bg.jpg'));
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty || !emailRegexp.hasMatch(value)) {
            return 'Email is required and should be valid';
          }
        },
        decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.white.withOpacity(0.2)),
        onSaved: (String value) {
          _formState['email'] = value;
        });
  }

  TextFormField _buildPasswordTextfield() {
    return TextFormField(
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password is required and should be greater then 6 digits';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white.withOpacity(0.2)),
      onSaved: (String value) {
        _formState['_password'] = value;
      },
    );
  }

  SwitchListTile _buildAcceptTerms() {
    return SwitchListTile(
        value: _termsAccepted,
        onChanged: (bool value) {
          setState(() {
            _termsAccepted = value;
          });
        },
        title: Text('Accept Terms'));
  }

  void _submitForm() {
    if (_globalKey.currentState.validate()) {
      return;
    }
    _globalKey.currentState.save();
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.8;

    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.all(15.0),
          child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Container(
                width: targetWidth,
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextfield(),
                      _buildAcceptTerms(),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        child: Text('Login'),
                        onPressed: _submitForm,
                      )
                    ],
                  ),
                ),
              ))),
        ));
  }
}