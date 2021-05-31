class YearGoal {
  final int id;
  final int year;
  final int price;

  YearGoal({this.id, this.year, this.price});

  factory YearGoal.fromJson(Map<String, dynamic> json) => YearGoal(
    id: json['id'],
    year: json['year'],
    price: json['price']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'year': year,
    'price': price
  };
}