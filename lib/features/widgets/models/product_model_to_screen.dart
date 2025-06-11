class HandcraftProduct {
  final String id;
  final String title;
  final double price;
  final double? offerPrice;
  final String description;
  final List<String> imageUrls;
  final double averageRating;
  final int totalReviews;
  final List<Comment> comments;

  HandcraftProduct({
    required this.id,
    required this.title,
    required this.price,
    this.offerPrice,
    required this.description,
    required this.imageUrls,
    required this.averageRating,
    required this.totalReviews,
    required this.comments,
  });
}

class Comment {
  final String userName;
  final String content;
  final DateTime date;

  Comment({
    required this.userName,
    required this.content,
    required this.date,
  });
}
