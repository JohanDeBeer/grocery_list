import 'dart:async';

import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/pin_model.dart';
import 'package:grocerylist/models/shop_list_model.dart';

class PinsBloc implements BlocBase {
  final _pinsController = StreamController<List<Pin>>.broadcast();

  StreamSink<List<Pin>> get _inPins => _pinsController.sink;

  Stream<List<Pin>> get pins => _pinsController.stream;

  PinsBloc() {
    getPins();
  }

  @override
  void dispose() {
    _pinsController.close();
  }

  void getPins() async {
    List<Pin> pins = await Pin.getPins();
    _inPins.add(pins);
  }
}
