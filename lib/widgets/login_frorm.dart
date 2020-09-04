import 'package:flutter/material.dart';
import 'package:flutter_api_rest/api/my_api.dart';
import 'package:flutter_api_rest/utils/responsive.dart';
import 'package:flutter_api_rest/widgets/input_text.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _password = '';

  _submit() {
    final isOk = _formKey.currentState.validate();
    print("form isOk $isOk ");
    if (isOk) {
      MyAPI.instance.login(context, email: _email, password: _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Positioned(
      bottom: 30,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.isTablet ? 450 : 300,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputText(
                keyboardType: TextInputType.emailAddress,
                label: "EMAIL ADDRESS",
                fontSize: responsive.dp(responsive.isTablet ? 4 : 2),
                onChanged: (text) {
                  _email = text;
                  print('El E-Mail es : $text');
                },
                validator: (text) {
                  if (!text.contains("@")) {
                    return "Invalid email";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: responsive.dp(4),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InputText(
                        label: "PASSWORD",
                        obscureText: true,
                        borderEnabled: false,
                        fontSize: responsive.dp(responsive.isTablet ? 4 : 2),
                        onChanged: (text) {
                          _password = text;
                          print('La Contraseña es : $text');
                        },
                        validator: (text) {
                          if (text.trim().length == 0) {
                            return "Invalid Password";
                          }
                          return null;
                        },
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.dp(responsive.isTablet ? 4 : 2),
                        ),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: responsive.dp(4),
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Sing in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.hp(2),
                    ),
                  ),
                  onPressed: _submit,
                  color: Colors.pinkAccent,
                ),
              ),
              SizedBox(
                height: responsive.dp(4),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to Friendly Desi?',
                    style: TextStyle(
                      fontSize: responsive.dp(2),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Sing up',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: responsive.dp(2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: responsive.dp(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
