import 'package:e_commerce/features/categories/catgories_pages/common_pages/handcraft_common_ui.dart';
import 'package:e_commerce/features/categories/catgories_pages/models/handcraft_model.dart';
import 'package:e_commerce/features/categories/catgories_pages/services/handcraft_service.dart';
import 'package:flutter/material.dart';

class Handcrafts extends StatefulWidget {
  const Handcrafts({super.key});

  @override
  State<Handcrafts> createState() => _HandcraftsState();
}

class _HandcraftsState extends State<Handcrafts> {
  late Future<List<HandcraftModel>> _handcraftProducts;

  @override
  void initState() {
    super.initState();
    _handcraftProducts = HandcraftService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Handcrafts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<HandcraftModel>>(
          future: _handcraftProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No handcraft products found."));
            }

            final products = snapshot.data!;

            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return InkWell(
                    onTap: () {
                      final selectedProduct = HandcraftModel(
                        id: product.id,
                        title: product.title,
                        description: product.description,
                        price: product.price,
                        discountAvailable: product.discountAvailable,
                        discountPercentage: product.discountPercentage,
                        primaryImageUrl: product.primaryImageUrl,
                        imageUrls: product.imageUrls,
                        tags: product.tags,
                        ratings: product.ratings, // ensure it's List<Rating>
                        averageRating: product.averageRating ?? 0.0,
                        totalReviews: product.totalReviews ?? 0,
                      );

                      final allProducts = products.map((p) => HandcraftModel(
                        id: p.id,
                        title: p.title,
                        description: p.description,
                        price: p.price,
                        discountAvailable: p.discountAvailable,
                        discountPercentage: p.discountPercentage,
                        primaryImageUrl: p.primaryImageUrl,
                        imageUrls: p.imageUrls,
                        tags: p.tags,
                        ratings: p.ratings,
                        averageRating: p.averageRating ?? 0.0,
                        totalReviews: p.totalReviews ?? 0,
                      )).toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandcraftCommonUi(
                            product: selectedProduct,
                            allProducts: allProducts,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                product.primaryImageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.description ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Rs. ${product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          },
        ),
      ),
    );
  }
}
