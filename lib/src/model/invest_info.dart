class InvestInfo {
  final int assetId;
  final String title;
  final String tag;
  final int price;

  InvestInfo({this.assetId, this.title, this.tag, this.price});

  factory InvestInfo.fromJson(Map<String, dynamic> json) => InvestInfo(
    assetId: json['id'],
    title: json['name'],
    tag: json['memo'],
    price: json['price']
  );

  Map<String, dynamic> toMap() => {
    'id': assetId,
    'title': title,
    'tag': tag,
    'price': price
  };
}