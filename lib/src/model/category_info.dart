class CategoryInfo {
  final int category;
  final int price;
  final String name;

  CategoryInfo({this.category, this.name, this.price});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) => CategoryInfo(
    category: json['category'],
    price: json['price'],
    name: json['name']
  );
}