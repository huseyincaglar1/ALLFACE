import 'package:demoaiemo/language/lang_provider.dart';
import 'package:demoaiemo/pages/camera_page.dart';
import 'package:demoaiemo/auth/auth_page.dart';
import 'package:demoaiemo/pages/home_page.dart';
import 'package:demoaiemo/pages/feedback_page.dart';
import 'package:demoaiemo/pages/verification_page.dart';
import 'package:demoaiemo/pages/profile_page.dart';
import 'package:demoaiemo/pages/setting_page.dart';
import 'package:demoaiemo/pages/suggestion_page.dart';
import 'package:demoaiemo/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/approved_activities_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) => LanguageProvider()), // Add LanguageProvider
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
          theme: Provider.of<ThemeProvider>(context).themeData,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('tr'), // Türkçe
          ],
          locale: languageProvider.locale,
          routes: {
            '/homepage': (context) => const HomePage(),
            '/camerapage': (context) => const CameraPage(),
            '/profilepage': (context) => const ProfilePage(),
            '/settingpage': (context) => const SettingPage(),
            '/suggestionpage': (context) => const SuggestionPage(),
            '/verificationpage': (context) => const VerificationPage(),
            '/apprrovedactivitiespage': (context) =>
                const ApprovedActivitiesPage(),
            '/feedbackpage': (context) => const FeedbackPage(),
          },
        );
      },
    );
  }
}
