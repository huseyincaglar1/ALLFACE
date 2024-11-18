import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference post = FirebaseFirestore.instance.collection('Posts');

  // Yeni bir gönderi ekler
  Future<void> addPost(String message, String? userEmail, String? mood, String? activityName) {
    return post.add({
      'UserEmail': userEmail,
      'PostMessage': message,
      'mood': mood,
      'activityName': activityName,
      'TimeStamp': Timestamp.now(),
    });
  }

  // Gönderiyi günceller
  Future<void> updatePost(String postId, String updatedMessage) async {
    await post.doc(postId).update({
      'PostMessage': updatedMessage,
      'TimeStamp': Timestamp.now(),
    });
  }

  // Gönderi akışını alır
  Stream<List<DocumentSnapshot>> getPostsStream() {
    Stream<QuerySnapshot> postsStream = post.snapshots();
    Stream<QuerySnapshot> activitiesStream = FirebaseFirestore.instance.collection('PublishedActivities').snapshots();

    return Rx.combineLatest2(postsStream, activitiesStream, (QuerySnapshot posts, QuerySnapshot activities) {
      List<DocumentSnapshot> combinedList = [
        ...posts.docs,
        ...activities.docs,
      ];
      combinedList.sort((a, b) {
        DateTime timestampA = (a['TimeStamp'] as Timestamp).toDate();
        DateTime timestampB = (b['TimeStamp'] as Timestamp).toDate();
        return timestampB.compareTo(timestampA); // Azalan sırayla sıralar
      });
      return combinedList; // Sıralı listeyi döndür
    });
  }
}
