import 'package:e_commerce/features/categories/widgets/banner_carousel.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  final List<Map<String, String>> categories = const [
    {
      "label": "Handcrafts",
      "image": "assets/categories/handcrafts.png",
      "route": "/handcrafts"
    },
    {
      "label": "Spices",
      "image": "assets/categories/spices.png",
      "route": "/spices"
    },
    {
      "label": "Herbal",
      "image": "assets/categories/herbal.png",
      "route": "/herbal"
    },
    {
      "label": "Clay Pots",
      "image": "assets/categories/pots.png",
      "route": "/claypots"
    },
    {
      "label": "Beverages",
      "image": "assets/categories/beverages.png",
      "route": "/beverages"
    },
    {
      "label": "Foods",
      "image": "assets/categories/foods.png",
      "route": "/foods"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const BannerCarousel(),
              const SizedBox(height: 24),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, category["route"]!),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                category["image"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                category["label"]!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
