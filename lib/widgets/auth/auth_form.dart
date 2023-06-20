import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  //const AuthForm({Key key}) : super(key: key);
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;

  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    //close the keyboard
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword,
        _userName,
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address!';
                      }
                      return null;
                    },
                    onSaved: (emailAddress) {
                      _userEmail = emailAddress;
                    },
                  ),
                  // ignore: sdk_version_ui_as_code
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length <= 4) {
                          return 'Please enter atleast 4 characters';
                        }
                        return null;
                      },
                      onSaved: (userName) {
                        _userName = userName;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length <= 7) {
                        return 'Password must be atleast 7 characters long!';
                      }
                      return null;
                    },
                    onSaved: (password) {
                      _userPassword = password;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.isLoading)
                    CircularProgressIndicator(
                      color: Theme.of(context).accentColor,
                    ),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      // color: Theme.of(context).accentColor,
                      // textColor: Colors.white,
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogin
                            ? 'Create New Account'
                            : 'I Already Have an Account',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // style: TextButton.styleFrom(
                      //   foregroundColor: Colors.indigo,
                      // ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
