import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/app/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      AppAssets.banner1,
      AppAssets.banner2,
      AppAssets.banner3,
      AppAssets.banner4,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: CarouselSlider.builder(
        itemCount: bannerImages.length,
        itemBuilder: (context, index, realIdx) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              bannerImages[index],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          );
        },
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
        ),
      ),
    );
  }
}
