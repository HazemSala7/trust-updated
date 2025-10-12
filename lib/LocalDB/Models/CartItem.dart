class CartItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final int categoryID;
  final String name_ar;
  final String name_en;
  final String image;
  final String notes;
  late final String size_ar;
  late final String size_en;
  final int size_id;
  final int selectedSizeIndex;
  final String color_en;
  final String color_ar;
  final int color_id;
  final List<String> sizes_en;
  final List<String> sizes_ar;
  final List<String> sizesIDs;
  final List<String> colorsNamesEN;
  final List<String> colorsNamesAR;
  final List<String> colorsImages;
  int quantity;

  CartItem(
      {this.id,
      required this.productId,
      required this.selectedSizeIndex,
      required this.size_id,
      required this.color_id,
      required this.categoryID,
      required this.name_ar,
      required this.name_en,
      required this.notes,
      required this.image,
      required this.size_ar,
      required this.size_en,
      required this.sizes_en,
      required this.sizes_ar,
      required this.sizesIDs,
      required this.colorsNamesEN,
      required this.colorsNamesAR,
      required this.colorsImages,
      required this.color_en,
      required this.color_ar,
      this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'selectedSizeIndex': selectedSizeIndex,
      'size_id': size_id,
      'notes': notes,
      'color_id': color_id,
      'categoryID': categoryID,
      'name_ar': name_ar,
      'name_en': name_en,
      'image': image,
      'sizes_ar': sizes_ar.join(','),
      'sizes_en': sizes_en.join(','),
      'sizesIDs': sizesIDs.join(','),
      'colorsNamesEN': colorsNamesEN.join(','),
      'colorsNamesAR': colorsNamesAR.join(','),
      'colorsImages': colorsImages.join(','),
      'size_ar': size_ar,
      'size_en': size_en,
      'color_en': color_en,
      'color_ar': color_ar,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      color_id: json['color_id'],
      selectedSizeIndex: json['selectedSizeIndex'],
      size_id: json['size_id'],
      notes: json['notes'],
      productId: json['productId'],
      categoryID: json['categoryID'],
      name_ar: json['name_ar'],
      name_en: json['name_en'],
      image: json['image'],
      sizes_en: (json['sizes_en'] as String).split(','),
      sizes_ar: (json['sizes_ar'] as String).split(','),
      sizesIDs: (json['sizesIDs'] as String).split(','),
      colorsImages: (json['colorsImages'] as String).split(','),
      colorsNamesEN: (json['colorsNamesEN'] as String).split(','),
      colorsNamesAR: (json['colorsNamesAR'] as String).split(','),
      size_ar: json['size_ar'],
      size_en: json['size_en'],
      color_en: json['color_en'],
      color_ar: json['color_ar'],
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    int? size_id,
    int? color_id,
    int? selectedSizeIndex,
    int? categoryID,
    String? name_ar,
    String? name_en,
    String? notes,
    String? image,
    List<String>? sizes_en,
    List<String>? sizes_ar,
    List<String>? sizesIDs,
    List<String>? colorsNamesEN,
    List<String>? colorsNamesAR,
    List<String>? colorsImages,
    String? size_ar,
    String? size_en,
    String? color_en,
    String? color_ar,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      color_id: color_id ?? this.color_id,
      size_id: size_id ?? this.size_id,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
      productId: productId ?? this.productId,
      notes: notes ?? this.notes,
      categoryID: categoryID ?? this.categoryID,
      sizes_ar: sizes_ar ?? this.sizes_ar,
      sizes_en: sizes_en ?? this.sizes_en,
      sizesIDs: sizesIDs ?? this.sizesIDs,
      colorsImages: colorsImages ?? this.colorsImages,
      colorsNamesEN: colorsNamesEN ?? this.colorsNamesEN,
      colorsNamesAR: colorsNamesAR ?? this.colorsNamesAR,
      name_ar: name_ar ?? this.name_ar,
      name_en: name_en ?? this.name_en,
      image: image ?? this.image,
      size_ar: size_ar ?? this.size_ar,
      size_en: size_en ?? this.size_en,
      color_en: color_en ?? this.color_en,
      color_ar: color_ar ?? this.color_ar,
      quantity: quantity ?? this.quantity,
    );
  }
}
