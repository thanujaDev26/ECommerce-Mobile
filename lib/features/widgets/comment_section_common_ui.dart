import 'dart:convert';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

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

    final userId = "mock-user-id";

    final response = await http.post(
      Uri.parse('https://your-api-url.com/api/ratings/${widget.productId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "rating": _userRating,
        "review": reviewText,
        "userId": userId,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Leave a Review',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          RatingBar.builder(
            initialRating: _userRating,
            minRating: 1,
            allowHalfRating: true,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber,),
            onRatingUpdate: (rating) {
              setState(() => _userRating = rating);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 3,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Write your comment here...',
              hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.white54 : Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.white54 : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.amber : Colors.blue,
                  width: 2,
                ),
              ),
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey.shade100,
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: _submitRating,
              icon: const Icon(Icons.send),
              label: const Text("Submit", style: TextStyle(
                color: Colors.white
              ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().primary,
                foregroundColor:Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
