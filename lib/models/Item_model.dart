class Item {
  int id;
  String name;
  int quantity;
  bool isBought;
  int listID;

  Item({
    this.id,
    this.name,
    this.quantity,
    this.isBought,
    this.listID,
  });

  factory Item.fromJson(Map<String, dynamic> json) => new Item(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        isBought: json["isBought"],
        listID: json["listID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "isBought": isBought,
        "listID": listID,
      };
}
