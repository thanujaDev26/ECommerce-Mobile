class HandcraftProduct {
  final String id;
  final String? title;
  final String? description;
  final double price;
  final bool discountAvailable;
  final double? discountPercentage;
  final String primaryImageUrl;
  final List<String> imageUrls;
  final double averageRating;
  final int totalReviews;

  HandcraftProduct({
    required this.id,
    this.title,
    this.description,
    required this.price,
    required this.discountAvailable,
    this.discountPercentage,
    required this.primaryImageUrl,
    required this.imageUrls,
    required this.averageRating,
    required this.totalReviews,
  });

  factory HandcraftProduct.fromJson(Map<String, dynamic> json) {
    return HandcraftProduct(
      id: json['id'],
      title: json['productName'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      discountAvailable: json['discount_available'],
      discountPercentage: json['discount_percentage'] != null
          ? double.tryParse(json['discount_percentage'].toString())
          : null,
      primaryImageUrl: json['primary_image_url'],
      imageUrls: List<String>.from(json['images_url'] ?? []),
      averageRating: double.tryParse(json['averageRating'].toString()) ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}
