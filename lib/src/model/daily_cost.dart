class DailyCost {
  final int id; // 아이디
  final String category; // 카테고리
  final String title; // 제목
  final int assetId; // 결제형태
  final int price; // 가격
  final String date; // 날짜
  final int type; // 수입 == 1 , 지출 == 2

  DailyCost({this.id, this.category, this.title, this.assetId, this.price, this.date, this.type});

  factory DailyCost.fromJson(Map<String, dynamic> json) => DailyCost(
    id: json['id'],
    category: json['category'],
    title: json['title'],
    assetId: json['asset_id'],
    price: json['price'],
    date: json['date'],
    type: json['type']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'title': title,
    'asset_id': assetId,
    'price': price,
    'date': date,
    'type': type
  };

}