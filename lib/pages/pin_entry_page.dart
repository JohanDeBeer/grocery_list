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
  bool _loginFailed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Please enter your pin',
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

  void _submit() async {
    String pin = '';
    _pin.forEach((item) {
      pin = '$pin$item';
    });
    if (widget.firstLogin) {
      if (Pin.validatePin(pin)) {
        await Pin.newPin(Pin(value: pin));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                child: ShopListsPage(),
                bloc: ShopListsBloc(),
              );
            },
          ),
        );
      } else {
        print("The Pin Is INVALID");
      }
    } else {
      if (await Pin.authPin(pin)) {
        print("login");
      } else {
        setState(() {
          _loginFailed = true;
          _pin.clear();
        });
      }
    }
  }

  void _buttonPress(val) {
    setState(() {
      if (val != "del") {
        if (_pin.length < 3) {
          _pin.add(val);
        } else if (_pin.length == 3) {
          _pin.add(val);
          _submit();
        } else {
          print('Full');
        }
      } else {
        if (_pin.length > 0) {
          _pin.removeLast();
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
                  color: _loginFailed ? Colors.red : Colors.blueGrey,
                  size: 40,
                ),
        );
      }
    }
    return _lstReturn;
  }
}
