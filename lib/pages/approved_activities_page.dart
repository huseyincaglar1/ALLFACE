import 'package:demoaiemo/util/my_background_img.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../util/my_list_tile.dart';

class ApprovedActivitiesPage extends StatefulWidget {
  const ApprovedActivitiesPage({super.key});

  @override
  _ApprovedActivitiesPageState createState() => _ApprovedActivitiesPageState();
}

class _ApprovedActivitiesPageState extends State<ApprovedActivitiesPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onaylanan Etkinlikler"),
      ),
      body: BackgroundContainer(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('Users')
                  .doc(user?.email)
                  .collection('ApprovedActivities')
                  .snapshots(),
              builder: (context, snapshot) {
                //burada içerik işleniyor
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final approvedActivities = snapshot.data!.docs;
                if (approvedActivities.isEmpty) {
                  return const Center(
                    child: Text("Onaylanmış bir etkinlik yok."),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: approvedActivities.length,
                    itemBuilder: (context, index) {
                      final activity = approvedActivities[index];
                      String activityName =
                          activity['activityName'] ?? "Bilinmiyor";
                      String mood = activity['mood'] ?? "Bilinmiyor";
                      DateTime approvalDate =
                          DateTime.parse(activity['approvalDate']);
                      return MyListTile(
                        title: activityName,
                        subTitle: mood,
                        time: approvalDate,
                        onEdit: () => publishActivity(activityName, mood),
                        actionType: 'publish',
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> publishActivity(String activityName, String mood) async {
    String comment = '';

    // Show dialog for user to input comment before publishing
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gönderi Paylaş'),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Biraz aktivitenden bahsetsene",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogdan çık
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                // Burada dialogu kapatmadan önce işlemi başlatıyoruz
                Navigator.of(context).pop(); // Dialogu kapat

                // Firestore'da veri kaydetme işlemini başlat
                publishToFirestore(activityName, mood, comment);
              },
              child: Text(
                'Paylaş',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> publishToFirestore(
      String activityName, String mood, String comment) async {
    if (user != null && comment.isNotEmpty) {
      try {
        await firestore.collection('PublishedActivities').add({
          'activityName': activityName,
          'mood': mood,
          'UserEmail': user!.email,
          'PostMessage': comment,
          'TimeStamp': Timestamp.now(),
        });
        // Başarılı olduğunda bir mesaj göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gönderi başarıyla paylaşıldı."),
          ),
        );
      } catch (e) {
        // Hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gönderi kaydedilirken hata oluştu: $e"),
          ),
        );
      }
    } else {
      // Kullanıcı girişi yoksa veya yorum boşsa hata göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kullanıcı girişi yapılmamış veya yorum boş."),
        ),
      );
    }
  }
}
