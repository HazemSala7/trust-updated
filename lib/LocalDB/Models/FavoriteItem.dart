class FavoriteItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final int categoryID;
  final String name;
  final String image;

  FavoriteItem({
    this.id,
    required this.productId,
    required this.categoryID,
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'categoryID': categoryID,
      'name': name,
      'image': image,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      productId: json['productId'],
      categoryID: json['categoryID'],
      name: json['name'],
      image: json['image'],
    );
  }

  FavoriteItem copyWith({
    int? id,
    int? productId,
    int? categoryID,
    String? name,
    String? image,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      categoryID: categoryID ?? this.categoryID,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}
