import 'package:e_commerce/features/dashboard/services/user_service.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_model.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_commerce/features/dashboard/services/recommendation_service.dart';


class RecommendedItems extends StatefulWidget {
  final UserProfile user;
  const RecommendedItems({super.key, required this.user});

  @override
  State<RecommendedItems> createState() => _RecommendedItemsState();
}

class _RecommendedItemsState extends State<RecommendedItems> {
  late Future<List<Map<String, dynamic>>> _filteredProducts;



  @override
  void initState() {
    super.initState();
    _filteredProducts = _loadAndFilter();
  }



  Future<List<Map<String, dynamic>>> _loadAndFilter() async {
    final allItems = await RecommendationService.fetchRecommendedItems();
    return RecommendationService().filterItems(allItems, widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _filteredProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final recommended = snapshot.data ?? [];

        if (recommended.isEmpty) {
          return const Center(child: Text("No personalized recommendations found."));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Recommended for you",
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: recommended.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final item = recommended[index];

                  final title = item["productName"] ?? "Unnamed";
                  final price = item["price"]?.toString() ?? "0";
                  final rating = double.tryParse(item["averageRating"]?.toString() ?? "0") ?? 0.0;
                  final image = item["primary_image_url"] ?? "https://via.placeholder.com/150";

                  return Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.grey.shade200,
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
                          child: Image.network(
                            // item["image"],
                            image,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            // item["title"],
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RatingBarIndicator(
                            rating: item["rating"]?.toDouble() ?? 0.0,
                            itemCount: 5,
                            itemSize: 16.0,
                            direction: Axis.horizontal,
                            itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "LKR ${item["price"]}"?.toString() ?? "0",
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
