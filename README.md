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
| **Topik** | Image Picker dengan StateSetter, Local Storage & Refactoring |

---

## 📋 Deskripsi Proyek

Proyek ini merupakan implementasi praktikum **Pertemuan 10** mata kuliah Pemrograman Mobile menggunakan framework **Flutter** dengan bahasa pemrograman **Dart**. Aplikasi ini membahas tiga konsep utama:

| Konsep | Implementasi |
|---|---|
| 🖼️ **Image + StateSetter** | Memilih & menampilkan gambar secara dinamis menggunakan `image_picker` dan `StateSetter` |
| 💾 **Local Storage** | Menyimpan & membaca data secara persisten menggunakan `shared_preferences` |
| 🔧 **Refactoring** | Pemisahan kode menjadi komponen modular, reusable widget, dan struktur folder yang bersih |

---

## 🗂️ Struktur Folder

lib/
├── models/        → product_model.dart
├── pages/         → home_page, login_page, product_detail, product_page
├── widgets/       → product_card.dart
└── main.dart

## 🚀 Cara Menjalankan Proyek

### Prasyarat

Pastikan sudah menginstal:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi **3.x ke atas**
- [Dart SDK](https://dart.dev/get-dart) (sudah termasuk dalam Flutter)
- Android Studio / VS Code dengan ekstensi Flutter
- Emulator Android / perangkat fisik (untuk uji kamera & galeri)

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

> ⚠️ **Catatan:** Fitur kamera dan galeri membutuhkan perangkat fisik atau emulator dengan API level 21+ dan izin yang sudah dikonfigurasi di `AndroidManifest.xml` / `Info.plist`.

---

## 📦 Dependensi yang Digunakan

| Package | Versi | Fungsi |
|---|---|---|
| `flutter` | SDK | Framework utama |
| `image_picker` | ^1.x.x | Mengambil gambar dari kamera / galeri |
| `shared_preferences` | ^2.x.x | Penyimpanan data lokal (key-value) |
| `path_provider` | ^2.x.x | Akses path direktori perangkat |
| `google_fonts` | ^6.x.x | Kustomisasi tipografi |

> Lihat `pubspec.yaml` untuk versi lengkap dan terbaru.

---

## ✨ Fitur & Konsep yang Diimplementasikan

---

### 🖼️ 1. Image Picker dengan StateSetter

Pengguna dapat memilih gambar dari **kamera** atau **galeri** perangkat. Gambar yang dipilih ditampilkan secara langsung (*real-time*) menggunakan `StateSetter` yang memungkinkan pembaruan UI di dalam fungsi callback tanpa perlu merebuild seluruh widget tree.

**Cara kerja:**
```dart
File? _selectedImage;

void _pickImage(StateSetter setState) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }
}
```

**Menampilkan gambar yang dipilih:**
```dart
_selectedImage != null
    ? Image.file(_selectedImage!, fit: BoxFit.cover)
    : Image.asset('assets/images/placeholder.png'),
```

**Konfigurasi izin Android (`AndroidManifest.xml`):**
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

**Konfigurasi izin iOS (`Info.plist`):**
```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi ini memerlukan akses kamera untuk mengambil foto.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi ini memerlukan akses galeri untuk memilih foto.</string>
```

---

### 💾 2. Local Storage dengan SharedPreferences

Data pengguna (misalnya nama, preferensi, atau path gambar) disimpan secara **persisten** di perangkat menggunakan `shared_preferences`, sehingga data tetap ada meski aplikasi ditutup dan dibuka kembali.

**Service layer (hasil refactoring):**
```dart
// lib/services/local_storage_service.dart

class LocalStorageService {
  static const String _keyNama    = 'user_nama';
  static const String _keyImagePath = 'user_image_path';

  // Menyimpan data
  static Future<void> saveNama(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNama, nama);
  }

  static Future<void> saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyImagePath, path);
  }

  // Membaca data
  static Future<String?> getNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNama);
  }

  static Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyImagePath);
  }

  // Menghapus data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

**Menggunakan service di dalam screen:**
```dart
// Simpan data saat user menekan tombol
await LocalStorageService.saveNama(_namaController.text);
await LocalStorageService.saveImagePath(_selectedImage!.path);

// Muat data saat halaman pertama kali dibuka
@override
void initState() {
  super.initState();
  _loadData();
}

void _loadData() async {
  final nama = await LocalStorageService.getNama();
  final imagePath = await LocalStorageService.getImagePath();
  setState(() {
    _nama = nama ?? '';
    if (imagePath != null) _selectedImage = File(imagePath);
  });
}
```

---

### 🔧 3. Refactoring

Kode diorganisasi ulang mengikuti prinsip **Separation of Concerns** dan **DRY (Don't Repeat Yourself)** agar lebih mudah dibaca, dipelihara, dan dikembangkan.

**Prinsip refactoring yang diterapkan:**

| Sebelum Refactoring | Sesudah Refactoring |
|---|---|
| Semua logika di dalam satu file `main.dart` | Dipisah ke `screens/`, `widgets/`, `services/` |
| Logika SharedPreferences tersebar di berbagai screen | Dipusatkan di `LocalStorageService` |
| Widget image picker ditulis berulang | Dibuat menjadi `ImagePickerWidget` yang reusable |
| Magic string untuk key storage | Konstanta di `constants.dart` |

**Contoh — widget yang di-refactor menjadi komponen terpisah:**
```dart
// lib/widgets/image_picker_widget.dart

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final VoidCallback onPickFromGallery;
  final VoidCallback onPickFromCamera;

  const ImagePickerWidget({
    super.key,
    this.image,
    required this.onPickFromGallery,
    required this.onPickFromCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: image != null
              ? FileImage(image!)
              : const AssetImage('assets/images/placeholder.png')
                  as ImageProvider,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: onPickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Galeri'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onPickFromCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Kamera'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## 📸 Screenshot Aplikasi

> *Tambahkan screenshot di sini setelah aplikasi dijalankan*

| Tampilan Awal | Pilih Gambar | Data Tersimpan |
|:---:|:---:|:---:|
| *(Sebelum gambar dipilih)* | *(Dialog sumber gambar)* | *(Data berhasil disimpan)* |

---

## 🐛 Troubleshooting

**Galeri / kamera tidak bisa dibuka?**
Pastikan izin sudah ditambahkan di `AndroidManifest.xml` dan `Info.plist`. Pada Android 13+, gunakan izin `READ_MEDIA_IMAGES`.

**Data tidak tersimpan setelah aplikasi restart?**
Periksa apakah `SharedPreferences.getInstance()` dipanggil dengan `await` dan pastikan `await prefs.setString(...)` tidak menghasilkan error.

**Gambar tidak tampil setelah restart?**
Path gambar dari galeri bisa berubah antar sesi. Pertimbangkan untuk menyalin gambar ke direktori lokal aplikasi menggunakan `path_provider` terlebih dahulu, lalu simpan path barunya.

---

## 📚 Referensi

- [Dokumentasi Resmi Flutter](https://flutter.dev/docs)
- [image_picker — pub.dev](https://pub.dev/packages/image_picker)
- [shared_preferences — pub.dev](https://pub.dev/packages/shared_preferences)
- [Flutter StateSetter](https://api.flutter.dev/flutter/widgets/StateSetter.html)
- [Flutter Refactoring Best Practices](https://docs.flutter.dev/perf/best-practices)
- Modul Pertemuan 10 — Pemrograman Mobile, Teknik Informatika

---

## ⚠️ Catatan

- Proyek ini dibuat untuk keperluan **tugas akademik**
- Dilarang menyalin kode untuk keperluan tugas mahasiswa lain
- Untuk pertanyaan, buka **Issues** pada halaman repositori ini

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik. © 2024 **Eva Carlia** — Teknik Informatika

---

<p align="center">Dibuat dengan ❤️ menggunakan Flutter & Dart</p>
