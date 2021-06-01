// 가계부 저장을 위한 모델
// 1건의 데이터에 대한 정보
class AssetContent {
  final int id;
  final int category; // 카테고리
  final String title; // 제목
  final int assetId; // (외래키) 자산연결 id (ex. 삼성카드, 현대카드, 신한은행)
  final int assetType; // 소득 or 지출   소득 == 1, 지출 == 2
  final int price; // 가격
  final String date;  // 날짜

  AssetContent( {this.id, this.assetId, this.date, this.category, this.price, this.title, this.assetType} );

  factory AssetContent.fromJson(Map<String, dynamic> json) => AssetContent(
    id: json['id'],
    category: json['category'],
    title: json['title'],
    assetId: json['asset_id'],
    assetType: json['asset_type'],
    price: json['price'],
    date: json['date']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'title': title,
    'asset_id': assetId,
    'asset_type': assetType,
    'price': price,
    'date': date,
  };
}