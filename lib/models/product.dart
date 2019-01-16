import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool favorite;
  final String userEmail;
  final String userId;

  Product({
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.userEmail,
    @required this.userId,
    this.favorite = false
  });
}
