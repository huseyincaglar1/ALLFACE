import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/system/helpers.dart';
import 'package:demoaiemo/util/labeled_radio_button.dart';
import 'package:demoaiemo/util/my_botton.dart';
import 'package:demoaiemo/util/labeled_location_button.dart';
import 'package:demoaiemo/util/my_textfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selectedOption = 1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String selectedGender = "Erkek";

  // Ön tanımlı meslek listesi
  final List<String> occupations = [
    "Medya Çalışanı", "Finans Çalışanı", "Öğrenci",
    "Doktor", "Mühendis", "Öğretmen", "Avukat", "Sanatçı", "Yazılımcı",
    "Müzisyen", "Yazar", "Pazarlamacı", "Yönetici",
    "Elektrikçi", "Tasarımcı", "Diğer"
  ];

  String? selectedOccupation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            _title(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(25.0),
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 25),
                  _loginform(),
                  const SizedBox(height: 10),
                  MyBotton(
                    text: "Kaydol",
                    onTap: registerUser,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hesabın var mı?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Giriş Yap",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser() async {
    // Yükleniyor dairesi göster
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Şifrelerin eşleştiğini kontrol et
    if (passwordConfirmController.text != passwordController.text) {
      Navigator.pop(context); // Yükleniyor dairesini kaldır
      displayMessageToUser("Şifre eşleşmedi!", context); // Hata ver
    } else {
      // Kullanıcı oluştur
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Kullanıcı dosyasını oluşturup Firestore'a ekle
        createUserDocument(userCredential);

        // Yükleniyor dairesini kaldır
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Yükleniyor dairesini kaldır
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  Widget _title() {
    return const SizedBox(
      child: Text(
        "A L L F A C E",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _loginform() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyTextfield(
                hintText: "Adınız",
                obscureText: false,
                controller: nameController,
                enabled: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyTextfield(
                hintText: "Soyadınız",
                obscureText: false,
                controller: surnameController,
                enabled: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyTextfield(
          hintText: "Mail Adresiniz",
          obscureText: false,
          controller: emailController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        MyTextfield(
          hintText: "Şifreniz",
          obscureText: true,
          controller: passwordController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        MyTextfield(
          hintText: "Şifrenizi Doğrula",
          obscureText: true,
          controller: passwordConfirmController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        LabeledRadio(
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
          controller: genderController,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          obscureText: false,
          decoration: const InputDecoration(
            labelText: 'Yaşınız',
            border: OutlineInputBorder(),
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(height: 10),

        // Meslek seçim kısmı
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchableDropdown.single(
              items: occupations.map((occupation) {
                return DropdownMenuItem<String>(
                  value: occupation,
                  child: Text(occupation),
                );
              }).toList(),
              value: selectedOccupation,
              hint: "Mesleğiniz",
              searchHint: "",
              onChanged: (value) {
                setState(() {
                  selectedOccupation = value;
                });
              },
              isExpanded: true,
            ),
            const SizedBox(height: 10),
              
          ],
        ),

        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MyTextfield(
                hintText: "Konumunuz:",
                obscureText: false,
                controller: locationController,
                enabled: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabeledLocationButton(
                controller: locationController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'Email': userCredential.user!.email,
        'Name': nameController.text,
        'Surname': surnameController.text,
        'Gender': genderController.text,
        'Age': ageController.text,
        'Occupation': selectedOccupation,
        'Location': locationController.text,
      });
    }
  }
}
