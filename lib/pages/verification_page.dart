import 'package:flutter/material.dart';
import 'dart:io'; // Dosya işlemleri için
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage için
import 'package:path/path.dart' as path; // Dosya adı ve uzantıları için

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ModalRoute ile gelen argumentleri alıyoruz
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String algilananDuygu = arguments?['emotion'] ?? 'Belirtilmemiş'; // Varsayılan değer
    final File? yakalananResimDosyasi = arguments?['capturedImageFile']; // Gelen fotoğraf

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doğrulama Sayfası"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ana sayfaya geri dön
            Navigator.pushReplacementNamed(context, '/homepage');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Algılanan Duygu: $algilananDuygu",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),

              // "Mutlu" butonu
              ElevatedButton(
                onPressed: () async {
                  if (algilananDuygu == "Mutlu" && yakalananResimDosyasi != null) {
                    await resmiFirebaseYukle(yakalananResimDosyasi, "Mutlu");
                  }
                  Navigator.pushReplacementNamed(context, '/suggestionpage',
                      arguments: {"emotion": "Mutlu"});
                },
                child: const Text("Mutlu"),
              ),
              const SizedBox(height: 20),

              // "Üzgün" butonu
              ElevatedButton(
                onPressed: () async {
                  if (algilananDuygu == "Üzgün" && yakalananResimDosyasi != null) {
                    await resmiFirebaseYukle(yakalananResimDosyasi, "Üzgün");
                  }
                  Navigator.pushReplacementNamed(context, '/suggestionpage',
                      arguments: {"emotion": "Üzgün"});
                },
                child: const Text("Üzgün"),
              ),
              const SizedBox(height: 20),

              // "Öfkeli" butonu
              ElevatedButton(
                onPressed: () async {
                  if (algilananDuygu == "Öfkeli" && yakalananResimDosyasi != null) {
                    await resmiFirebaseYukle(yakalananResimDosyasi, "Öfkeli");
                  }
                  Navigator.pushReplacementNamed(context, '/suggestionpage',
                      arguments: {"emotion": "Öfkeli"});
                },
                child: const Text("Öfkeli"),
              ),
              const SizedBox(height: 20),

              // "Duygu Analizine Geri Dön" butonu
              ElevatedButton(
                onPressed: () {
                  // Kamera sayfasına geri dön
                  Navigator.pushReplacementNamed(context, '/camerapage',
                      arguments: {"emotion": algilananDuygu});
                },
                child: const Text("Duygu Analizine Geri Dön"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Resmi Firebase Storage'a yüklemek için fonksiyon
  Future<void> resmiFirebaseYukle(File resimDosyasi, String duygu) async {
    try {
      // Resim dosyasını yüklemek için bir referans oluştur
      final String dosyaAdi = path.basename(resimDosyasi.path);
      final String duyguKlasoru = duyguKlasorunuGetir(duygu);
      final Reference ref = FirebaseStorage.instance.ref('$duyguKlasoru/$dosyaAdi');

      // Resmi Firebase Storage'a yükle
      await ref.putFile(resimDosyasi);
      print('Resim Firebase Storage\'a başarıyla yüklendi: $dosyaAdi');
    } catch (e) {
      print('Resim yüklenemedi: $e');
    }
  }

  // Algılanan duyguya göre klasör adını belirle
  String duyguKlasorunuGetir(String duygu) {
    switch (duygu) {
      case 'Mutlu':
        return 'Mutlu';
      case 'Üzgün':
        return 'Üzgün';
      case 'Öfkeli':
        return 'Öfkeli';
      default:
        throw Exception('Tanımlanmayan duygu: $duygu');
    }
  }
}
