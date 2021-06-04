// 하루치 가계부 데이터
class DailyCost {
  final int id; // 아이디
  final int categoryId; // 카테고리 아이디
  final String category; // 카테고리
  final String title; // 제목
  final int assetId; // 자산아이디
  final String assetNm; // 자산명
  final int price; // 가격
  final String date; // 날짜
  final int type; // 수입 == 1 , 지출 == 2

  DailyCost(
      {this.id,
      this.category,
      this.title,
      this.assetNm,
      this.price,
      this.date,
      this.type,
      this.assetId,
      this.categoryId});

  factory DailyCost.fromJson(Map<String, dynamic> json) => DailyCost(
      id: json['id'],
      categoryId: json['category_id'],
      category: json['category'],
      title: json['title'],
      assetId: json['asset_id'],
      assetNm: json['asset_nm'],
      price: json['price'],
      date: json['date'],
      type: json['type']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': categoryId,
        'title': title,
        'asset_id': assetId,
        'asset_type': type,
        'price': price,
        'date': date,
      };

  Map<String, dynamic> toMapNoId() => {
    'category': categoryId,
    'title': title,
    'asset_id': assetId,
    'asset_type': type,
    'price': price,
    'date': date,
  };
}
