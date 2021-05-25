class AssetContent {
  final int id;
  final int assetType; //소득=1, 지출=2
  final String date;  // 날짜
  final int category; // 카테고리
  final int price; // 가격
  final String title; // 제목
  final String memo; // 메모
  final int bank; // 은행 or 카드사 (DB에 있음)

  AssetContent( {this.id, this.assetType, this.date, this.category, this.price, this.title, this.memo, this.bank} );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'title': title,
    'asset_type': assetType,
    'price': price,
    'date': date,
  };
}