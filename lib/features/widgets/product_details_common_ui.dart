import 'dart:convert';

import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/widgets/comment_section_common_ui.dart';
import 'package:e_commerce/features/widgets/similar_products_list.dart';
import 'package:e_commerce/features/dashboard/viewmodels/handcraft_model.dart';
import 'package:e_commerce/features/notifications/notification_service.dart';
import 'package:e_commerce/features/cart/cart_service.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandcraftProductDetailPage extends StatefulWidget {
  final HandcraftProduct product;
  final List<HandcraftProduct> allProducts;

  const HandcraftProductDetailPage({
    super.key,
    required this.product,
    required this.allProducts,
  });

  @override
  State<HandcraftProductDetailPage> createState() => _HandcraftProductDetailPageState();
}

class _HandcraftProductDetailPageState extends State<HandcraftProductDetailPage> {
  bool _showAllReviews = false;

  Future<void> _addToCartAndNotify(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to add items to cart")),
      );
      return;
    }

    try {
      await CartService.addToCart(widget.product.id, token);

      await NotificationService.createNotification(
        token,
        'You added "${widget.product.title}" to your cart.',
      );
      CustomSnackbar.show(context, message: "Added to cart",backgroundColor: Colors.green,
        icon: Icons.check_circle,);
    } catch (e) {
      CustomSnackbar.show(context, message: "Failed to add to cart: ${e}",backgroundColor: Colors.red,
        icon: Icons.warning_rounded,);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final reviews = widget.product.ratings ?? [];
    final visibleReviews = _showAllReviews ? reviews : reviews.take(2).toList();
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.title ?? 'Untitled',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors().primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            tooltip: 'Add to Cart',
            onPressed: () => _addToCartAndNotify(context),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            Image.network(
              widget.product.primaryImageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title ?? 'Untitled',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingBarIndicator(
                    rating: widget.product.averageRating,
                    itemCount: 5,
                    itemSize: 20.0,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "LKR - ${widget.product.price}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.description ?? 'No description available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  if (reviews.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: visibleReviews.map((rating) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: theme.colorScheme.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                    child: const Icon(Icons.person, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RatingBarIndicator(
                                          rating: rating.rating.toDouble(),
                                          itemCount: 5,
                                          itemSize: 18.0,
                                          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          rating.review,
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Posted on: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (reviews.length > 2)
                      TextButton(
                        onPressed: () {
                          setState(() => _showAllReviews = !_showAllReviews);
                        },
                        child: Text(
                          _showAllReviews ? 'Show Less' : 'See All Reviews',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 24),
                  ProductCommentBox(
                    productId: widget.product.id,
                    onReviewSubmitted: () {
                      // TODO: Refresh ratings logic
                    },
                  ),
                  SimilarProductsList(
                    currentProduct: widget.product,
                    allProducts: widget.allProducts,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
