import 'package:e_commerce/features/widgets/models/product_model_to_screen.dart';
import 'package:e_commerce/features/widgets/product_details_common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_commerce/app/constants/app_colors.dart';

class TopItemsGrid extends StatelessWidget {
  const TopItemsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> topItems = [
      {
        "title": "Lacquered Wooden Elephant",
        "price": 4500.00,
        "rating": 4.8,
        "image": "assets/demo_images/wooden_elephant.png",
      },
      {
        "title": "Handwoven Dumbara Mats",
        "price": 3200.00,
        "rating": 4.7,
        "image": "assets/demo_images/dumbara_mats.png",
      },
      {
        "title": "Traditional Clay Pot Set",
        "price": 2800.00,
        "rating": 4.6,
        "image": "assets/demo_images/traditional_clay_pot.png",
      },
      {
        "title": "Hand-Carved Wooden Mask",
        "price": 6500.00,
        "rating": 4.9,
        "image": "assets/demo_images/hand_carved_wooden_mask.png",
      },
      {
        "title": "Coconut Shell Ladle Set",
        "price": 1200.00,
        "rating": 4.5,
        "image": "assets/demo_images/coconut_shell_ladle_set.png",
      },
      {
        "title": "Beeralu Lace Table Runner",
        "price": 3800.00,
        "rating": 4.6,
        "image": "assets/demo_images/beeralu_lace_table_runner.png",
      },
    ];

    return GridView.builder(
      itemCount: topItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = topItems[index];
        final handcraftProduct = HandcraftProduct(
          id: index.toString(),
          title: item["title"],
          price: item["price"],
          offerPrice: null,
          description: "This is a beautifully handcrafted item called ${item["title"]}.",
          imageUrls: [
            "https://via.placeholder.com/400x300.png?text=${Uri.encodeComponent(item["title"])}"
          ],
          averageRating: item["rating"],
          totalReviews: 120,
          comments: [
            Comment(userName: "Alice", content: "Loved it!", date: DateTime.now()),
            Comment(userName: "Bob", content: "Amazing quality.", date: DateTime.now()),
          ],
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HandcraftProductDetailPage(product: handcraftProduct),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black12 : Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.asset(
                    item["image"],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item["title"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RatingBarIndicator(
                    rating: item["rating"],
                    itemCount: 5,
                    itemSize: 18.0,
                    direction: Axis.horizontal,
                    itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "\$${item["price"].toString()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors().primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
