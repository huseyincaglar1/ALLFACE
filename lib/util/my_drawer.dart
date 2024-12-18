import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            DrawerHeader(
              child: Icon(Icons.favorite_border_outlined,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.inversePrimary,
              leading: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("A N A S A Y F A"),
              contentPadding: const EdgeInsets.only(left: 35),
              onTap: () {
                //zaten homepage de, sadece drawer ı popla
                Navigator.pop(context);
              },
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.inversePrimary,
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("P R O F İ L"),
              contentPadding: const EdgeInsets.only(left: 35),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profilepage');
              },
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.inversePrimary,
              contentPadding: const EdgeInsets.only(left: 35),
              leading: Icon(
                Icons.done_all_rounded,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("O N A Y L A N A N L A R"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/apprrovedactivitiespage');
              },
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.inversePrimary,
              contentPadding: const EdgeInsets.only(left: 35),
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("A Y A R L A R"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settingpage');
              },
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.inversePrimary,
              contentPadding: const EdgeInsets.only(left: 35),
              leading: Icon(
                Icons.feedback, // 'feedback' ikonu burada kullanılıyor
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("G E R İ B İ L D İ R İ M"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/feedbackpage');
              },
            ),
          ],
        ),
        ListTile(
          textColor: Theme.of(context).colorScheme.inversePrimary,
          contentPadding: const EdgeInsets.only(left: 35),
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          title: const Text("Ç I K I Ş"),
          onTap: () {
            Navigator.pop(context);
            logout();
          },
        ),
      ]),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}
