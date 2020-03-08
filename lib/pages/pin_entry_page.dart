import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/shop_list_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/pin_model.dart';
import 'package:grocerylist/pages/shop_list_page.dart';
import 'package:grocerylist/widgets/keypad.dart';

class PinEntryPage extends StatefulWidget {
  PinEntryPage(this.firstLogin);

  final bool firstLogin;

  @override
  _PinEntryPageState createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  List<String> _pin = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Please ${widget.firstLogin ? 'Create' : 'Enter'} your pin',
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildPinView().isNotEmpty ? _buildPinView() : <Widget>[],
          ),
          Center(
            child: Keypad(
              onPress: (val) => _buttonPress(val),
            ),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String title, String subtitle) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.redAccent,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          )),
    );
  }

  void _submit() async {
    String pin = '';
    _pin.forEach((item) {
      pin = '$pin$item';
    });
    if (widget.firstLogin) {
      _createAccount(pin);
    } else {
      _login(pin);
    }
  }

  void _createAccount(String pin) async {
    if (Pin.validatePin(pin)) {
      await Pin.newPin(Pin(value: pin));
      _nextPage();
    } else {
      showInSnackBar("The Pin Is INVALID",
          "Do not use birth year, repeating or consecutive numbers");
      setState(() {
        _pin.clear();
      });
    }
  }

  void _login(String pin) async {
    if (await Pin.authPin(pin)) {
      _loginSuccess();
    } else {
      _loginFail();
    }
  }

  void _loginSuccess() {
    _nextPage();
  }

  void _nextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider(
            child: ShopListsPage(),
            bloc: ShopListsBloc(),
          );
        },
      ),
    );
  }

  void _loginFail() {
    showInSnackBar("Pin Incorrect", "Please try again");
    setState(() {
      _pin.clear();
    });
  }

  void _buttonPress(val) {
    setState(() {
      if (val == "del") {
        if (_pin.length > 0) {
          _pin.removeLast();
        }
      } else if (val == 'clear') {
        _pin.clear();
      } else {
        if (_pin.length < 3) {
          _pin.add(val);
        } else if (_pin.length == 3) {
          _pin.add(val);
          _submit();
        } else {
          print('Full');
        }
      }
    });
  }

  List<Widget> _buildPinView() {
    List<Widget> _lstReturn = new List();
    for (int i = 0; i < 4; i++) {
      if (_pin.length > i) {
        _lstReturn.add(
          widget.firstLogin
              ? Text(
                  _pin[i],
                  style: TextStyle(fontSize: 20),
                )
              : Icon(
                  Icons.check_circle,
                  color: Colors.blueGrey,
                  size: 40,
                ),
        );
      } else {
        _lstReturn.add(
          widget.firstLogin
              ? Text(
                  '_',
                  style: TextStyle(fontSize: 20),
                )
              : Icon(
                  Icons.check_box_outline_blank,
            color: Colors.blueGrey,
                  size: 40,
                ),
        );
      }
    }
    return _lstReturn;
  }
}
