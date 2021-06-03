class SmsAssetList {
  final int id;
  final String word;
  final String cardNm;
  final String cardTag;

  SmsAssetList({this.id, this.word, this.cardNm, this.cardTag});

  factory SmsAssetList.fromJson(Map<String, dynamic> json) => SmsAssetList(
    id: json['id'],
    word: json['word'],
    cardNm: json['card_nm'],
    cardTag: json['card_tag']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'word': word,
    'card_nm': cardNm,
    'card_tag': cardTag
  };
}