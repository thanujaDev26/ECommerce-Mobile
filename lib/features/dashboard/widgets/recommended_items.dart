import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/app/constants/app_assets.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recommended = [
      {
        "title": "Kithul Honey Gift Bottle",
        "price": 8.75,
        "rating": 4.4,
        "image": "assets/demo_images/kithul-honey.png",
      },
      {
        "title": "Traditional Garayaka Mask",
        "price": 25.00,
        "rating": 4.8,
        "image": "assets/demo_images/garayaka.png",
      },
      {
        "title": "Wooden Spice Rack Set",
        "price": 19.99,
        "rating": 4.6,
        "image": "assets/demo_images/wood_rack.png",
      },
      {
        "title": "Painted Terracotta Incense Holder",
        "price": 7.25,
        "rating": 4.5,
        "image": "assets/demo_images/holder.png",
      },
    ];


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Recommended for you",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              return Container(
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
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
                      child:
                      Image.asset(
                        item["image"],
                        height: 150,
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
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RatingBarIndicator(
                        rating: item["rating"],
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
                        "\$${item["price"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors().primary,
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
  }
}
