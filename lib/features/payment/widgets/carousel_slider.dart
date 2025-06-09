import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<String> imagePaths = [
  "assets/banners/banner1.png",
  "assets/banners/banner2.png",
  "assets/banners/banner3.png",
];

Widget build(BuildContext context) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 200,
      autoPlay: true,
      enlargeCenterPage: true,
      viewportFraction: 1.0,
      aspectRatio: 16 / 9,
      autoPlayInterval: Duration(seconds: 3),
    ),
    items: imagePaths.map((path) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}