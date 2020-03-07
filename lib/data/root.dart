import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/pin_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/pages/pin_entry_page.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  PinsBloc _pinsBloc;

  @override
  void initState() {
    _pinsBloc = BlocProvider.of<PinsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _pinsBloc.pins,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return PinEntryPage(true);
            } else {
              return PinEntryPage(false);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
