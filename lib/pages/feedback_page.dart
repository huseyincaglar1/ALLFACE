import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  String? _selectedCategory = 'Mutlu'; // Varsayılan kategori
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Kullanıcı bilgilerini Firebase'den çek
  Future<void> _fetchUserInfo() async {
    try {
      if (currentUser != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser?.email)
            .get();

        if (userSnapshot.exists) {
          setState(() {
            _ageController.text = userSnapshot['Age']?.toString() ?? '';
            _genderController.text = userSnapshot['Gender'] ?? '';
            _occupationController.text = userSnapshot['Occupation'] ?? '';
          });
        } else {
          print('Kullanıcı bilgileri bulunamadı');
        }
      }
    } catch (e) {
      print('Kullanıcı bilgileri alınırken hata oluştu: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // Sayfa açıldığında kullanıcı bilgilerini al
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  // Özel Snackbar mesajı
  Future<void> _showCustomSnackbar(String message) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcının mesajı kapatmasını engeller
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.none, // Alt çizgi yok
              ),
            ),
          ),
        );
      },
    );

    // Mesajı 3 saniye sonra kapat
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.of(context).pop(); // Eğer sayfa açıksa kapat
  }

  // Firebase'e geri bildirim gönder
  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isNotEmpty) {
      try {
        String category = _selectedCategory ?? 'Mutlu';

        await FirebaseFirestore.instance.collection('Feedbacks').add({
          'Feedback': _feedbackController.text,
          'Category': category,
          'Age': _ageController.text,
          'Gender': _genderController.text,
          'Occupation': _occupationController.text,
          'Timestamp': FieldValue.serverTimestamp(),
        });

        // Başarılı mesajı göster
        await _showCustomSnackbar('Geri bildiriminiz alındı!');

        // Alanları temizle
        _feedbackController.clear();
        _ageController.clear();
        _genderController.clear();
        _occupationController.clear();

        setState(() {
          _selectedCategory = 'Mutlu';
        });

        await _fetchUserInfo();
      } catch (e) {
        await _showCustomSnackbar(
            'Geri bildirim gönderilirken bir hata oluştu.');
      }
    } else {
      await _showCustomSnackbar('Lütfen geri bildiriminizi yazın.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geri Bildirim"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Lütfen geri bildirim kategorisini seçin:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                ChoiceChip(
                  label: Text('Mutlu'),
                  selected: _selectedCategory == 'Mutlu',
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 'Mutlu';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Üzgün'),
                  selected: _selectedCategory == 'Üzgün',
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 'Üzgün';
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Öfkeli'),
                  selected: _selectedCategory == 'Öfkeli',
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = 'Öfkeli';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Geri bildiriminizi buraya yazın:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Geri bildiriminizi buraya yazın...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Gönder'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
