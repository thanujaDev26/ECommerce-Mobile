import 'package:e_commerce/features/widgets/comment_section_common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/widgets/chat_with_seller_fab.dart';
import 'package:e_commerce/features/widgets/similar_products_list.dart';
import 'package:e_commerce/features/notifications/notification_service.dart';
import 'package:e_commerce/features/cart/cart_service.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:e_commerce/features/dashboard/viewmodels/handcraft_model.dart';


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
        'You added "${widget.product.title ?? 'a product'}" to your cart.',
      );
      CustomSnackbar.show(
        context,
        message: "Added to cart",
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: "Failed to add to cart: $e",
        backgroundColor: Colors.red,
        icon: Icons.warning_rounded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
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
      body: Stack(
        children: [
          GestureDetector(
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
                        itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(
                          locale: 'en_US',
                          symbol: 'LKR ',
                          decimalDigits: 2,
                        ).format(widget.product.price),
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
                      const SizedBox(height: 24),

                      ProductCommentBox(productId: widget.product.id),
                      const SizedBox(height: 24),
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
          ChatWithSellerFAB(
            sellerId: widget.product.sellerId,
            sellerName: widget.product.sellerName ?? 'Seller',
            unreadMessages: 3,
          ),
        ],
      ),
    );
  }
}
