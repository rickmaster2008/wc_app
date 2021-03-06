import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart';
import 'package:wc_app/common/errors.common.dart';
import 'package:wc_app/common/functions.common.dart';
import 'package:wc_app/components/input.component.dart';
import 'package:wc_app/config/wc.config.dart';
import 'package:woocommerce/woocommerce.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _emailController = TextEditingController();

  final GlobalKey<InputComponentState> _firstNameKey =
          GlobalKey<InputComponentState>(),
      _lastNameKey = GlobalKey<InputComponentState>(),
      _usernameKey = GlobalKey<InputComponentState>(),
      _passwordKey = GlobalKey<InputComponentState>(),
      _emailKey = GlobalKey<InputComponentState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        centerTitle: true,
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            if (_firstNameKey.currentState.validate() &&
                _lastNameKey.currentState.validate() &&
                _usernameKey.currentState.validate() &&
                _passwordKey.currentState.validate() &&
                _emailKey.currentState.validate()) {
              showLoading(context);
              WooCustomer customer = WooCustomer(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                username: _usernameController.text,
                password: _passwordController.text,
                email: _emailController.text,
              );
              bool created = false;
              try {
                created = await woocommerce.createCustomer(customer);
              } catch (e) {
                showSnackBar(
                    context: context,
                    msg: parse(e.toString()).documentElement.text,
                    type: SnackBarType.danger);
              }
              if (created) {
                _firstNameController.clear();
                _lastNameController.clear();
                _usernameController.clear();
                _passwordController.clear();
                _emailController.clear();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Usuario creado'),
                ));
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            }
          },
          child: Icon(Icons.check),
        ),
      ),
      body: Column(
        children: [
          InputComponent(
            key: _firstNameKey,
            validator: _emptyValidate,
            controller: _firstNameController,
            hint: 'Nombre',
            keyboard: TextInputType.name,
          ),
          InputComponent(
            key: _lastNameKey,
            validator: _emptyValidate,
            controller: _lastNameController,
            hint: 'Apellido',
            keyboard: TextInputType.name,
          ),
          InputComponent(
            key: _usernameKey,
            validator: _emptyValidate,
            controller: _usernameController,
            hint: 'Nombre de usuario',
          ),
          InputComponent(
            key: _emailKey,
            validator: _emptyValidate,
            controller: _emailController,
            keyboard: TextInputType.emailAddress,
            hint: 'Email',
          ),
          InputComponent(
            key: _passwordKey,
            validator: _emptyValidate,
            controller: _passwordController,
            hint: 'Contraseña',
            isPassword: true,
          ),
        ],
      ),
    );
  }

  String _emptyValidate(String s) {
    if (s.isEmpty || s == '') return ErrorsCommon.required;
    return null;
  }
}
