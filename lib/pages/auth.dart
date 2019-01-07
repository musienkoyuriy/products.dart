import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email = '';
  String _password = '';
  bool _termsAccepted = false;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
        image: AssetImage('assets/bg.jpg'));
  }

  TextField _buildEmailTextField() {
    return TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.white.withOpacity(0.2)),
        onChanged: (String value) {
          setState(() {
            _email = value;
          });
        });
  }

  TextField _buildPasswordTextfield() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
          fillColor: Colors.white.withOpacity(0.2)),
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
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
              ))),
        ));
  }
}
