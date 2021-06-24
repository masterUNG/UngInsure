import 'dart:convert';

class InsureModel {
  final String id;
  final String insure;
  final String detail;
  final String price;
  final String promote;
  InsureModel({
    required this.id,
    required this.insure,
    required this.detail,
    required this.price,
    required this.promote,
  });

  InsureModel copyWith({
    String? id,
    String? insure,
    String? detail,
    String? price,
    String? promote,
  }) {
    return InsureModel(
      id: id ?? this.id,
      insure: insure ?? this.insure,
      detail: detail ?? this.detail,
      price: price ?? this.price,
      promote: promote ?? this.promote,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'insure': insure,
      'detail': detail,
      'price': price,
      'promote': promote,
    };
  }

  factory InsureModel.fromMap(Map<String, dynamic> map) {
    return InsureModel(
      id: map['id'],
      insure: map['insure'],
      detail: map['detail'],
      price: map['price'],
      promote: map['promote'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InsureModel.fromJson(String source) => InsureModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InsureModel(id: $id, insure: $insure, detail: $detail, price: $price, promote: $promote)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is InsureModel &&
      other.id == id &&
      other.insure == insure &&
      other.detail == detail &&
      other.price == price &&
      other.promote == promote;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      insure.hashCode ^
      detail.hashCode ^
      price.hashCode ^
      promote.hashCode;
  }
}
