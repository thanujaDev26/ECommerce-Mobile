import 'package:e_commerce/features/dashboard/viewmodels/handcraft_model.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_profile.dart';
import 'package:e_commerce/features/widgets/product_details_common_ui.dart';
import 'package:flutter/material.dart';
// import 'package:e_commerce/features/product_detail/views/handcraft_product_detail.dart';


class RecommendedItems extends StatefulWidget {
  final UserProfile user;
  final List<HandcraftProduct> allProducts;

  const RecommendedItems({
    Key? key,
    required this.user,
    required this.allProducts,
  }) : super(key: key);

  @override
  State<RecommendedItems> createState() => _RecommendedItemsState();
}

class _RecommendedItemsState extends State<RecommendedItems> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  List<HandcraftProduct> _getRecommended() {
    return widget.allProducts.where((product) {
      final tags = product.tags?.map((e) => e.toLowerCase()).toList() ?? [];

      final matchesGender = tags.contains(widget.user.gender?.toLowerCase());
      final matchesLocation = tags.contains(widget.user.location?.toLowerCase());
      final matchesAge = _matchesAgeTag(tags, widget.user.age);

      return matchesGender || matchesLocation || matchesAge;
    }).toList();
  }

  bool _matchesAgeTag(List<String> tags, int age) {
    if (age < 18) return tags.contains("teen") || tags.contains("child");
    if (age >= 18 && age <= 50) return tags.contains("adult");
    return tags.contains("senior");
  }

  @override
  Widget build(BuildContext context) {
    final recommended = _getRecommended();

    if (recommended.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No recommended products found."),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: recommended.length,
        itemBuilder: (context, index) {
          final product = recommended[index];
          return _buildCard(context, product);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, HandcraftProduct product) {
    return InkWell(
        onTap: () {
          print("Tapped on ${product.title}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HandcraftProductDetailPage(
                product: product,
                allProducts: widget.allProducts,
              ),
            ),
          );
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.primaryImageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
      
              // Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.title ?? "Unnamed Product",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Rs. ${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
      
              const Spacer(),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(product.averageRating.toStringAsFixed(1)),
                    const Spacer(),
                    Text("${product.totalReviews} reviews", style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
