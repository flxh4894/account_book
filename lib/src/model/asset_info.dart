class AssetInfo {
  final int id;
  final String name;
  final String memo;
  final int type;
  final int isFavorite;

  AssetInfo({this.id, this.name, this.memo, this.type, this.isFavorite});

  factory AssetInfo.fromJson(Map<String, dynamic> json) => AssetInfo(
    id: json['id'],
    name: json['name'],
    memo: json['memo'],
    type: json['type'],
    isFavorite: json['is_favorite']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'memo': memo,
    'type': type,
    'is_favorite': isFavorite
  };

}