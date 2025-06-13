class Rating {
  final double rating;
  final String review;

  Rating({
    required this.rating,
    required this.review,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      review: json['review'] ?? '',
    );
  }
}
