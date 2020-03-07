import 'package:flutter/material.dart';

class Keypad extends StatelessWidget {
  Keypad({this.onPress});

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 300,
        maxWidth: 300,
      ),
      child: _generateKeypad(),
    );
  }

  Widget _generateKeypad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buttonRow(['1', '2', '3']),
        _buttonRow(['4', '5', '6']),
        _buttonRow(['7', '8', '9']),
        _buttonRow(['', '0', 'del']),
      ],
    );
  }

  Widget _buttonRow(List<String> buttons) {
    List<Widget> _builtButtons = new List();
    buttons.forEach((val) {
      _builtButtons.add(
        Container(
          height: 50,
          width: 90,
          child: FittedBox(
            child: OutlineButton(
              color: Colors.blue,
              borderSide: BorderSide(color: Colors.blue, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              //backgroundColor: Colors.blueGrey,
              onPressed: () {
                onPress(val);
              },
              child: val != 'del'
                  ? Text(
                      val,
                      style: TextStyle(fontSize: 40),
                    )
                  : Icon(
                      Icons.backspace,
                      size: 25,
                    ),
            ),
          ),
        ),
      );
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _builtButtons,
    );
  }
}
