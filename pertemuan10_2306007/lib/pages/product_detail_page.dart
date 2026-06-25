import 'package:flutter/material.dart';
import 'package:pertemuan10_2306007/models/product_models.dart';
import 'dart:convert';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Product")),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: 120,
                    height: 130,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 120, color: Colors.grey),
              Text(
                product.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Rp ${product.price}"),
              SizedBox(height: 10),
              Text(product.description),
            ],
          ),
        ),
      );
  }
}