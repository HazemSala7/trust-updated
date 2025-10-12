class Silder {
  String image;
  String product_id;

  Silder({
    required this.image,
    required this.product_id,
  });

  factory Silder.fromJson(Map<String, dynamic> json) {
    // Safely parse product_id with type checking
    String productId = "";
    var urlData = json['url'];
    
    if (urlData != null) {
      if (urlData is String) {
        productId = urlData;
      } else if (urlData is int) {
        productId = urlData.toString();
      } else {
        productId = urlData.toString();
      }
    }
    
    return Silder(
      image: json['image']?.toString() ?? "",
      product_id: productId,
    );
  }
}
