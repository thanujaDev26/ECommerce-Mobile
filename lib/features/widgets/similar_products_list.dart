import 'package:flutter/material.dart';
import 'package:e_commerce/features/dashboard/viewmodels/top_handcraft_product.dart';
import 'package:e_commerce/features/widgets/product_details_common_ui.dart';

class SimilarProductsList extends StatelessWidget {
  final HandcraftProduct currentProduct;
  final List<HandcraftProduct> allProducts;

  const SimilarProductsList({
    super.key,
    required this.currentProduct,
    required this.allProducts,
  });

  List<HandcraftProduct> getSimilarProducts() {
    final currentTags = currentProduct.tags ?? [];
    return allProducts
        .where((p) =>
        p.id != currentProduct.id &&
        p.tags?.any((tag) => currentTags.contains(tag)) == true)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final similar = getSimilarProducts();

    if (similar.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Similar Products',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            itemBuilder: (context, index) {
              final product = similar[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HandcraftProductDetailPage(product: product, allProducts: allProducts,),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          product.primaryImageUrl,
                          height: 100,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "LKR ${product.price.toStringAsFixed(0)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(product.averageRating.toStringAsFixed(1)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
