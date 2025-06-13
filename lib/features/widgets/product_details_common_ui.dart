import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/dashboard/viewmodels/top_handcraft_product.dart';

class HandcraftProductDetailPage extends StatelessWidget {
  final HandcraftProduct product;

  const HandcraftProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(product.title ?? 'Untitled')),
      body: ListView(
        children: [
          Image.network(
            product.primaryImageUrl,
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
                  product.title ?? 'Untitled',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                RatingBarIndicator(
                  rating: product.averageRating,
                  itemCount: 5,
                  itemSize: 20.0,
                  itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
                ),
                const SizedBox(height: 8),
                Text(
                  "LKR - ${product.price}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors().primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description ?? 'Untitled',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
