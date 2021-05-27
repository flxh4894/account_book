class CreditCard {
  final int id; // 아이디
  final int assetId; // 자산아이디(외래키)
  final String cardNm; // 카드이름
  final String tag; // 카드설명
  final int price; // 현재사용금액
  final int performance; // 실적금액
  final int payDate; // 결제일

  CreditCard(
      {this.id,
      this.assetId,
      this.cardNm,
      this.tag,
      this.price,
      this.performance,
      this.payDate});

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
    id: json['id'],
    assetId: json['asset_id'],
    cardNm: json['card_nm'],
    tag: json['tag'],
    price: json['price'],
    performance: json['performance'],
    payDate: json['pay_date']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'asset_id': assetId,
    'card_nm': cardNm,
    'tag': tag,
    'price': price,
    'performance': performance,
    'pay_date': payDate
  };

}