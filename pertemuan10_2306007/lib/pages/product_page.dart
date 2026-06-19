import 'package:flutter/material.dart';
import '../models/product_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> products = [];

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> productList = prefs.getStringList('products') ?? [];
    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> productList = products.map((item) => item.toJson()).toList();

    await prefs.setStringList('products', productList);
  }

  Future<void> addProduct(ProductModel product) async {
    setState(() {
      products.add(product);
    });

    await saveProducts();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added successfully')));
  }

  Future<void> updateProduct(int index, ProductModel updatedProduct) async {
    setState(() {
      products[index] = updatedProduct;
    });

    await saveProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product updated successfully')),
    );
  }

  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });

    await saveProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully')),
    );
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void showForm({ProductModel? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );

    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );

    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Add Product" : "Update Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newProduct = ProductModel(
                name: nameController.text,
                description: descriptionController.text,
                price: int.parse(priceController.text),
              );

              if (product == null) {
                addProduct(newProduct);
              } else {
                updateProduct(index!, newProduct);
              }

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showForm(),
                    child: Text("Add Product"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  
                  return ProductCard(
                    product: product,
                    onDelete: () => deleteProduct(index),
                    onEdit: () => showForm(product: product, index: index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
