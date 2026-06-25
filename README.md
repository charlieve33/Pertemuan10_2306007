# 📱 Pertemuan 10 — Pemrograman Mobile (Flutter/Dart)

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Local%20Storage-SharedPreferences-orange?style=for-the-badge"/>
</p>

---

## 👤 Identitas Mahasiswa

| Keterangan | Detail |
|---|---|
| **Nama** | Eva Carlia |
| **NIM** | 2306007 |
| **Mata Kuliah** | Pemrograman Mobile |
| **Program Studi** | Teknik Informatika |
| **Pertemuan** | 10-13 |
| **Topik** | Image dengan StateSetter, Local Storage & Refactoring |

---

## 📋 Deskripsi Proyek

Proyek ini merupakan implementasi praktikum **Pertemuan 10** mata kuliah Pemrograman Mobile menggunakan framework **Flutter** dan bahasa **Dart**. Aplikasi ini adalah aplikasi **katalog produk** yang dilengkapi halaman login, daftar produk, dan detail produk, serta mengimplementasikan tiga konsep utama:

| Konsep | Implementasi |
|---|---|
| 🖼️ **Image + StateSetter** | Menampilkan gambar produk dari URL API secara dinamis dengan pembaruan state menggunakan `StateSetter` |
| 💾 **Local Storage** | Menyimpan sesi login dan data pengguna secara persisten menggunakan `shared_preferences` |
| 🔧 **Refactoring** | Kode dipisah ke dalam folder `models/`, `pages/`, dan `widgets/` agar modular dan bersih |

---

## 🗂️ Struktur Folder

```
Pertemuan10_2306007/
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   ├── models/
│   │   └── product_model.dart       # Model data produk
│   ├── pages/
│   │   ├── home_page.dart           # Halaman utama setelah login
│   │   ├── login_page.dart          # Halaman login dengan local storage
│   │   ├── product_detail_page.dart # Halaman detail produk
│   │   └── product_page.dart        # Halaman daftar produk
│   └── widgets/
│       └── product_card.dart        # Widget kartu produk (reusable)
├── pubspec.yaml
└── README.md
```

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat

Pastikan sudah menginstal:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi **3.x ke atas**
- Dart SDK (sudah termasuk dalam Flutter)
- Android Studio / VS Code + ekstensi Flutter & Dart
- Emulator Android atau perangkat fisik

### Langkah Instalasi

**1. Clone repository**
```bash
git clone https://github.com/charlieve33/Pertemuan10_2306007.git
```

**2. Masuk ke direktori proyek**
```bash
cd Pertemuan10_2306007
```

**3. Install semua dependensi**
```bash
flutter pub get
```

**4. Jalankan aplikasi**
```bash
flutter run
```

---

## 📦 Dependensi yang Digunakan

| Package | Fungsi |
|---|---|
| `flutter` | Framework utama |
| `shared_preferences` | Penyimpanan data lokal (key-value) |
| `http` | Mengambil data produk dari API |

> Lihat `pubspec.yaml` untuk versi lengkap.

---

## 📁 Penjelasan File

### `lib/main.dart`
Entry point aplikasi. Mengecek status login dari local storage untuk menentukan halaman awal — jika sudah login langsung ke `HomePage`, jika belum diarahkan ke `LoginPage`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(MaterialApp(
    title: 'Pertemuan 10',
    home: isLoggedIn ? const HomePage() : const LoginPage(),
  ));
}
```

---

### `lib/models/product_model.dart`
Kelas model untuk merepresentasikan data produk dari API. Berisi constructor dan factory `fromJson` sebagai hasil **refactoring** agar data terstruktur dan terpisah dari logika UI.

```dart
class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}
```

---

### `lib/pages/login_page.dart`
Halaman login yang menyimpan status autentikasi ke **Local Storage** menggunakan `SharedPreferences`, sehingga sesi pengguna tetap tersimpan meski aplikasi ditutup dan dibuka kembali.

```dart
void _login() async {
  final prefs = await SharedPreferences.getInstance();

  if (_usernameController.text == 'admin' &&
      _passwordController.text == '1234') {
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('username', _usernameController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username atau password salah!')),
    );
  }
}
```

---

### `lib/pages/home_page.dart`
Halaman utama setelah login berhasil. Menampilkan nama pengguna yang dibaca dari local storage dan menyediakan tombol logout yang menghapus sesi.

```dart
void _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginPage()),
  );
}
```

---

### `lib/pages/product_page.dart`
Halaman daftar produk yang mengambil data dari API dan menampilkannya dalam bentuk grid/list menggunakan widget `ProductCard`. Menggunakan `StateSetter` melalui `StatefulBuilder` untuk memperbarui tampilan gambar produk secara dinamis di dalam dialog tanpa merebuild seluruh halaman.

```dart
void _showImagePreview(BuildContext context, ProductModel product) {
  String currentImage = product.image;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  currentImage,
                  height: 200,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Perbarui gambar secara dinamis menggunakan StateSetter
                      currentImage = 'https://via.placeholder.com/200';
                    });
                  },
                  child: const Text('Ganti Gambar'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
```

---

### `lib/pages/product_detail_page.dart`
Halaman detail produk yang menerima objek `ProductModel` dari halaman sebelumnya dan menampilkan informasi lengkap: gambar (dari URL), nama, kategori, harga, dan deskripsi produk.

```dart
class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(product.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Kategori: ${product.category}'),
            Text('Harga: \$${product.price}',
                style: const TextStyle(color: Colors.green, fontSize: 16)),
            const SizedBox(height: 8),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
```

---

### `lib/widgets/product_card.dart`
Widget kartu produk yang dapat digunakan ulang (*reusable*) — ini adalah hasil utama dari proses **refactoring**, memisahkan tampilan kartu dari logika halaman agar kode lebih bersih dan tidak berulang.

```dart
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('\$${product.price}',
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✨ Ringkasan Implementasi Konsep Utama

### 🖼️ Image + StateSetter
Gambar produk ditampilkan dari **URL API** menggunakan `Image.network()`. `StateSetter` dipakai melalui `StatefulBuilder` di dalam dialog agar gambar dapat diperbarui secara lokal tanpa merebuild seluruh widget tree halaman.

### 💾 Local Storage (SharedPreferences)
| Aksi | Kode |
|---|---|
| Simpan sesi login | `prefs.setBool('is_logged_in', true)` |
| Baca status login | `prefs.getBool('is_logged_in') ?? false` |
| Simpan username | `prefs.setString('username', value)` |
| Logout / hapus sesi | `prefs.clear()` |

### 🔧 Refactoring
| Sebelum | Sesudah |
|---|---|
| Semua kode di `main.dart` | Dipisah ke `models/`, `pages/`, `widgets/` |
| Data produk di-hardcode di UI | Dipindah ke `ProductModel` dengan `fromJson` |
| Kartu produk ditulis berulang | Dijadikan `ProductCard` yang reusable |

---

## 📸 Screenshot Aplikasi

> *Tambahkan screenshot di sini setelah aplikasi dijalankan*

| Login Page | Home Page | Product Page | Product Detail |
|:---:|:---:|:---:|:---:|
| *(Halaman login)* | *(Beranda)* | *(Daftar produk)* | *(Detail produk)* |

---

## 🐛 Troubleshooting

**Gagal login?**
Periksa username dan password yang digunakan, pastikan sesuai yang didefinisikan di `login_page.dart`.

**Data login hilang setelah restart?**
Pastikan `WidgetsFlutterBinding.ensureInitialized()` dipanggil sebelum `runApp()` di `main.dart`.

**Gambar produk tidak tampil?**
Pastikan perangkat/emulator terhubung ke internet karena gambar diambil dari URL API eksternal (`Image.network`).

---

## 📚 Referensi

- [Dokumentasi Resmi Flutter](https://flutter.dev/docs)
- [shared_preferences — pub.dev](https://pub.dev/packages/shared_preferences)
- [StatefulBuilder (StateSetter)](https://api.flutter.dev/flutter/widgets/StatefulBuilder-class.html)
- [Image.network — Flutter API](https://api.flutter.dev/flutter/widgets/Image/Image.network.html)
- Modul Pertemuan 10 — Pemrograman Mobile, Teknik Informatika

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik. © 2024 **Eva Carlia** — Teknik Informatika

---
