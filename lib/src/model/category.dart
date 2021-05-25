class Category {
  int id;
  String name;
  int type;

  Category({this.id, this.name, this.type});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    type: json['type']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type
  };
}