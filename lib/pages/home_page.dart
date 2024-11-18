import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/database/firestore.dart';
import 'package:demoaiemo/language/lang_switcher.dart';
import 'package:demoaiemo/util/my_background_img.dart';
import 'package:demoaiemo/util/my_drawer.dart';
import 'package:demoaiemo/util/my_list_tile.dart';
import 'package:demoaiemo/util/my_post_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController newPostController = TextEditingController();
  final TextEditingController personalActivityController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  String? selectedMood;
  List<String> moods = ["Öfkeli", "Mutlu", "Üzgün"]; // Ruh hali seçenekleri

  void postMessage() async {
    String postMessage = newPostController.text.trim();
    String personalActivity = personalActivityController.text.trim();

    if (postMessage.isNotEmpty && selectedMood != null && user != null) {
      String? userEmail = user?.email;
      await database.addPost(postMessage, userEmail, selectedMood, personalActivity); // Güncellenmiş metod çağrısı

      // Alanları temizle
      newPostController.clear();
      personalActivityController.clear();
      setState(() {
        selectedMood = null; // Seçilen ruh halini sıfırla
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("A L L F A C E"),
        actions: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const LanguageSwitcher(showText: false),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Ruh hali seçimi
                              DropdownButtonFormField<String>(
                                value: selectedMood,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                  labelText: AppLocalizations.of(context)!.howYouFeel,
                                ),
                                items: moods.map((String mood) {
                                  return DropdownMenuItem<String>(
                                    value: mood,
                                    child: Text(mood),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMood = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 5),
                              // Kişisel etkinlik girişi
                              TextField(
                                obscureText: false,
                                controller: personalActivityController,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: AppLocalizations.of(context)!.createAnctivity,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Mesaj girişi
                              TextField(
                                obscureText: false,
                                controller: newPostController,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: AppLocalizations.of(context)!.letsHearIt,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        MyPostButton(onTap: postMessage) // Gönderi butonu
                      ],
                    ),
                  ),
                  // Gönderi akışını dinleyen StreamBuilder
                  StreamBuilder<List<DocumentSnapshot>>(
                    stream: database.getPostsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final combinedPosts = snapshot.data!;

                        if (combinedPosts.isEmpty) {
                          return Center(child: Text(AppLocalizations.of(context)!.noPostYet));
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: combinedPosts.length,
                            itemBuilder: (context, index) {
                              final post = combinedPosts[index];
                              String message = post['PostMessage'];
                              String userEmail = post['UserEmail'];
                              Timestamp timestamp = post['TimeStamp'];
                              String actName = (post.data() as Map<String, dynamic>)['activityName'] ?? '';
                              String mood = (post.data() as Map<String, dynamic>)['mood'] ?? '';

                              return MyListTile(
                                title: [
                                  "Aktivite: $actName", // Activity her zaman eklenir
                                  "Ruh Hali: $mood",       // Mood her zaman eklenir
                                  message,             // Mesaj her zaman eklenir
                                ].join('\n'), // Liste öğelerini birleştir
                                subTitle: userEmail,
                                time: timestamp.toDate(),
                                actionType: 'publish',     // Aksiyon türü
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(child: Text("No data available."));
                      }
                    },
                  )

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              height: 100,
              width: 100,
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/camerapage');
                },
                backgroundColor: Colors.black,
                hoverColor: Colors.red[700],
                child: const Icon(
                  Icons.camera,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
