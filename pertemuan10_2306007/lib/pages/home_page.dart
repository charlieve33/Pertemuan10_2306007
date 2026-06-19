import 'package:flutter/material.dart';
import 'package:pertemuan10_2306007/pages/product_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import '../models/product_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  List<ProductModel> products = [];
  int totalProducts = 4;

  @override
  void initState() {
    super.initState();
    getUser();
    loadProducts();
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> productList = prefs.getStringList('products') ?? [];
    totalProducts = productList.length;
    setState(() {
      products = productList.reversed
          .take(3)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLogin', false);
    await prefs.remove('username');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.home, size: 80, color: Colors.blue),

                  const SizedBox(height: 15),

                  Text(
                    "Selamat Datang, $username",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Anda berhasil login ke aplikasi Flutter",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ Text("Total Produk: $totalProducts.toString()",),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductPage()),
                  );
                },
                child: const Text("Lihat Semua"),
              ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
