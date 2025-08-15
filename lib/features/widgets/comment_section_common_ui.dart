import 'dart:convert';
import 'package:e_commerce/app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';

class ProductCommentBox extends StatefulWidget {
  final String productId;
  final VoidCallback? onReviewSubmitted;

  const ProductCommentBox({
    super.key,
    required this.productId,
    this.onReviewSubmitted,
  });

  @override
  State<ProductCommentBox> createState() => _ProductCommentBoxState();
}

class _ProductCommentBoxState extends State<ProductCommentBox> {
  final TextEditingController _commentController = TextEditingController();
  double _userRating = 3.0;

  List<dynamic> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final response = await http.get(
        Uri.parse('$BASE_URL/api/v1/ratings/products/${widget.productId}'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            _reviews = data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _reviews = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() => _isLoading = false);
        CustomSnackbar.show(
          context,
          message: 'Failed to load reviews.',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      CustomSnackbar.show(
        context,
        message: 'Error loading reviews: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  Future<void> _submitRating() async {
    final reviewText = _commentController.text.trim();
    if (reviewText.isEmpty) {
      CustomSnackbar.show(
        context,
        message: "Please enter a comment.",
        backgroundColor: Colors.amber,
        icon: Icons.warning_rounded,
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) {
      CustomSnackbar.show(
        context,
        message: "You must be logged in to submit a review.",
        backgroundColor: Colors.red,
        icon: Icons.lock,
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$BASE_URL/api/v1/ratings/products/${widget.productId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "rating": _userRating,
        "review": reviewText,
      }),
    );

    if (response.statusCode == 201) {
      CustomSnackbar.show(
        context,
        message: "Thank you for your feedback!",
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
      setState(() {
        _commentController.clear();
        _userRating = 3.0;
      });
      await _fetchReviews();
      widget.onReviewSubmitted?.call();
    } else {
      CustomSnackbar.show(
        context,
        message: "Failed to submit review.",
        backgroundColor: Colors.red,
        icon: Icons.warning_rounded,
      );
    }
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = review['rating']?.toDouble() ?? 0.0;
    final comment = review['review'] ?? '';
    final createdAt = review['createdAt'] ?? '';
    final user = review['User'] ?? {};
    final userName = user['fName'] ?? 'Anonymous';
    final avatarUrl = user['avatar'];

    final replies = review['Replies'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/logo.png') as ImageProvider,
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            RatingBarIndicator(
              rating: rating,
              itemCount: 5,
              itemSize: 16,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            ),
            const SizedBox(height: 6),
            Text(comment),
            const SizedBox(height: 6),
            Text(
              'Posted on: ${createdAt.split('T').first}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (replies.isNotEmpty) ...[
              const Divider(height: 12, color: Colors.grey),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: replies.map((reply) {
                  final replyText = reply['replyText'] ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Seller: $replyText",
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildReviewsSlider() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_reviews.isEmpty) return const Text('No reviews yet.');

    final visibleReviews = _reviews.length > 3 ? _reviews.sublist(0, 3) : _reviews;

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: visibleReviews.length,
            controller: PageController(viewportFraction: 0.85),
            itemBuilder: (context, index) => _buildReviewCard(visibleReviews[index]),
          ),
        ),
        if (_reviews.length > 3)
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: _reviews.map((r) => _buildReviewCard(r)).toList(),
                ),
              );
            },
            child: const Text('View All Reviews'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildReviewsSlider(),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 12),
        Text(
          'Leave a Review',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        RatingBar.builder(
          initialRating: _userRating,
          minRating: 1,
          allowHalfRating: true,
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) => setState(() => _userRating = rating),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _commentController,
          maxLines: 3,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Write your comment here...',
            hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDarkMode ? Colors.white54 : Colors.grey),
            ),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[800] : Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
            onPressed: _submitRating,
            icon: const Icon(Icons.send),
            label: const Text("Submit", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
