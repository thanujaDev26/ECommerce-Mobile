import 'package:e_commerce/features/widgets/similar_products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/dashboard/viewmodels/top_handcraft_product.dart';



class HandcraftProductDetailPage extends StatelessWidget {
  final HandcraftProduct product;
  final List<HandcraftProduct> allProducts;

  const HandcraftProductDetailPage({super.key, required this.product, required this.allProducts});

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
                if (product.ratings?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Customer Reviews',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...product.ratings!.map((rating) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Circle Avatar Placeholder (Initial or Icon)
                            CircleAvatar(
                              backgroundColor: AppColors().primary.withOpacity(0.1),
                              child: const Icon(Icons.person, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            // Review Details
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
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Posted on: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                SimilarProductsList(currentProduct: product, allProducts: allProducts,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
