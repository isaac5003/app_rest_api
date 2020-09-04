import 'package:flutter/material.dart';
import 'package:flutter_api_rest/api/my_api.dart';
import 'package:flutter_api_rest/utils/dialogs.dart';
import 'package:flutter_api_rest/utils/responsive.dart';
import 'package:flutter_api_rest/widgets/input_text.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '', _password = '', _userName = '';

  _submit() async {
    final isOk = _formKey.currentState.validate();
    print("form isOk $isOk ");
    if (isOk) {
      await MyAPI.instance.register(
        context,
        username: _userName,
        email: _email,
        password: _password,
      );
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
                label: "USER NAME",
                fontSize: responsive.dp(responsive.isTablet ? 4 : 2),
                onChanged: (text) {
                  _userName = text;
                  print('El E-Mail es : $text');
                },
                validator: (text) {
                  if (text.trim().length < 5) {
                    return "Invalid username";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: responsive.dp(4),
              ),
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
              InputText(
                keyboardType: TextInputType.emailAddress,
                label: "PASSWORD",
                obscureText: true,
                fontSize: responsive.dp(responsive.isTablet ? 4 : 2),
                onChanged: (text) {
                  _password = text;
                  print('El E-Mail es : $text');
                },
                validator: (text) {
                  if (text.trim().length < 6) {
                    return "Invalid password";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: responsive.dp(4),
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Sing up',
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
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: responsive.dp(2),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Sing in',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: responsive.dp(2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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
