class Silder {
  String image;
  String product_id;

  Silder({
    required this.image,
    required this.product_id,
  });

  factory Silder.fromJson(Map<String, dynamic> json) {
    return Silder(
      image: json['image'] ?? "",
      product_id: json['url'] ?? "",
    );
  }
}
