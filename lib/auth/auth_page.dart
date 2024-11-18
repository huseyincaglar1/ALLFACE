import 'package:demoaiemo/auth/login_or_register.dart';
import 'package:demoaiemo/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder( //listen to the authantication
        stream: FirebaseAuth.instance.authStateChanges(), //make us sure the user logged in
        builder: (context, snapshot) {
        //kullanıcı giriş yaptı
        if(snapshot.hasData){
          return const HomePage();
        }

        //kullanıcı giriş yapılmadı
        else{
          return const LoginOrRegister();
        }

      },
      ),
    );
  }
}