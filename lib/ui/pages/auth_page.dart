import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/Item/item_states.dart';
import 'package:inventory/bloc/app/app_bloc.dart';
import 'package:inventory/bloc/app/app_events.dart';
import 'package:inventory/bloc/app/app_states.dart';
import 'package:inventory/bloc/auth/auth_bloc.dart';
import 'package:inventory/bloc/auth/auth_events.dart';
import 'package:inventory/bloc/auth/auth_states.dart';
import 'package:inventory/models/constants.dart';
import 'package:inventory/ui/widgets/invent_button.dart';

class AuthPage extends StatefulWidget {
  static const routName = '/auth' ;
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController =
  TextEditingController(text: '');
  AuthMode _authMode = AuthMode.Login;

  @override
  void initState() {
    if (BlocProvider.of<AuthBloc>(context).state is AuthInitialState)
      BlocProvider.of<AuthBloc>(context).add(AuthAutoLoginEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedState)
                BlocProvider.of<AppBloc>(context).add(FetchItemsAppEvent());
            },
          ),
          BlocListener<AppBloc, AppState>(
            listener: (context, state) {
            },
          ),
          BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
           },
          )
        ],
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Card(
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        child: FractionallySizedBox(
                          widthFactor: 0.96,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 4,
                              ),
                              _buildEmailTextField(),
                              _buildPasswordTextField(),
                              (_authMode == AuthMode.SignUp)
                                  ? _buildPasswordConfirmTextField()
                                  : Container(),
                              FlatButton(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Switch to ${_authMode == AuthMode.Login
                                      ? 'Signup'
                                      : 'Login'}',
                                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 12),
                                ),
                                onPressed: () {
                                  if (_authMode == AuthMode.Login) {
                                    setState(() {
                                      _authMode = AuthMode.SignUp;
                                    });
                                  } else {
                                    setState(() {
                                      _authMode = AuthMode.Login;
                                    });
                                  }
                                },
                              ),
                              InventoryButton(
                                  _authMode == AuthMode.Login
                                      ? 'LOGIN'
                                      : 'SIGNUP',
                                      () =>
                                      _submitForm(
                                          context,
                                          BlocProvider
                                              .of<AuthBloc>(context)
                                              .authService
                                              .authenticate)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextFormField(
        textAlign: TextAlign.center,
        initialValue: _formData['email'],
        decoration: InputDecoration(
          hintText: 'E-Mail',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Please enter a valid email';
          } else
            return null;
        },
        onSaved: (String value) {
          _formData['email'] = value;
        },
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Password',
        ),
        obscureText: true,
        controller: _passwordTextController,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return 'Password invalid';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['password'] = value;
        },
      ),
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextFormField(
        textAlign: TextAlign.center,
        initialValue: _formData['password'],
        decoration: InputDecoration(
          hintText: 'Confirm Password',
        ),
        obscureText: true,
        validator: (String value) {
          if (_passwordTextController.text != value &&
              _authMode == AuthMode.SignUp) {
            return 'Passwords do not match.';
          } else
            return null;
        },
      ),
    );
  }

  void _submitForm(BuildContext context, Function authenticate) async {
    if (!_formKey.currentState.validate()/* || !_formData['acceptTerms']*/) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (successInformation['success']) {
      BlocProvider.of<AppBloc>(context).add(FetchItemsAppEvent());
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }
}
