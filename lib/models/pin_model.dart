import 'package:grocerylist/data/database.dart';

class Pin {
  final int id;
  final String value;

  Pin({this.id, this.value});

  factory Pin.fromJson(Map<String, dynamic> json) => new Pin(
        id: json["id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
      };

  static newPin(Pin pin) async {
    final db = await DBProvider.db.database;
    var res = await db.insert('pin', pin.toJson());
    return res;
  }

  static getPins() async {
    final db = await DBProvider.db.database;
    var res = await db.query('pin');
    List<Pin> pins =
    res.isNotEmpty ? res.map((item) => Pin.fromJson(item)).toList() : [];
    return pins;
  }

  static validatePin(String pin) {
    bool valid = RegExp(r"^(?!(.)\1{3})(?!19|20)\d{4}$").hasMatch(pin);
    int numbers = "01234567890".indexOf(pin);
    int numbersRev = "09876543210".indexOf(pin);
    if (valid == true && numbers < 0 && numbersRev < 0) {
      return true;
    } else {
      return false;
    }
  }

  static authPin(String pin) async {
    final db = await DBProvider.db.database;
    var res = await db.query('pin', where: 'value = ?', whereArgs: [pin]);
    return res.isNotEmpty;
  }

  static isFirstLogin() async {
    final db = await DBProvider.db.database;
    var res = await db.query('pin');
    return res.isEmpty;
  }
}
