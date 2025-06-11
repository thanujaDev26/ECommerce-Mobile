import 'package:e_commerce/features/widgets/models/product_model_to_screen.dart';
import 'package:e_commerce/features/widgets/similar_products_common_ui.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HandcraftProductDetailPage extends StatelessWidget {
  final HandcraftProduct product;

  const HandcraftProductDetailPage({super.key, required this.product});

  List<HandcraftProduct> _getSimilarProducts() {
    return [
      HandcraftProduct(
        id: "101",
        title: "Traditional Clay Pot Set",
        price: 2800.00,
        offerPrice: null,
        description: "A classic handmade clay pot set.",
        imageUrls: ["assets/demo_images/traditional_clay_pot.png", "assets/demo_images/beeralu_lace_table_runner.png"],
        averageRating: 4.6,
        totalReviews: 95,
        comments: [],
      ),
      HandcraftProduct(
        id: "102",
        title: "Beeralu Lace Table Runner",
        price: 3800.00,
        offerPrice: 3500.00,
        description: "Elegant Beeralu lace table runner.",
        imageUrls: ["assets/demo_images/beeralu_lace_table_runner.png","assets/demo_images/traditional_clay_pot.png"],
        averageRating: 4.7,
        totalReviews: 80,
        comments: [],
      ),
      // add more as needed...
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isOffer = product.offerPrice != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Added to cart")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageCarousel(),
            if (isOffer) _offerTag(),
            const SizedBox(height: 10),
            _titleAndPrice(),
            const Divider(thickness: 1),
            _description(),
            const Divider(thickness: 1),
            _ratingInfo(),
            const Divider(thickness: 1),
            _commentsSection(context),
            const SizedBox(height: 24),
            SimilarProducts(similarProducts: _getSimilarProducts()),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }


  Widget _imageCarousel() {
    return CarouselSlider(
      options: CarouselOptions(height: 250.0, enlargeCenterPage: true),
      items: product.imageUrls.map((url) {
        return Builder(
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(url, fit: BoxFit.cover),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _offerTag() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Special Offer",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _titleAndPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (product.offerPrice != null)
                Text(
                  "\$${product.offerPrice!.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (product.offerPrice != null) const SizedBox(width: 8),
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  color: product.offerPrice != null ? Colors.grey : Colors.black,
                  decoration: product.offerPrice != null
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        product.description,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _ratingInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 20),
          const SizedBox(width: 6),
          Text(
            "${product.averageRating.toStringAsFixed(1)} / 5.0",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text("(${product.totalReviews} reviews)",
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _commentsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User Comments",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          ...product.comments.map((c) => Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.userName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  c.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${c.date.day}/${c.date.month}/${c.date.year}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

}
