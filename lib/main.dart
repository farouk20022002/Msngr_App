import 'package:chat_material3/layout.dart';
import 'package:chat_material3/provider/provider.dart';
import 'package:chat_material3/screens/auth/login_screen.dart';
import 'package:chat_material3/screens/auth/setup_profile.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderApp(),
      child: Consumer<ProviderApp>(
        builder:(context, value, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: value.themeMode,
            darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Color(value.mainColor), brightness: Brightness.dark)),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Color(value.mainColor), brightness: Brightness.light),
              useMaterial3: true,
            ),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (FirebaseAuth.instance.currentUser!.displayName == "" ||
                        FirebaseAuth.instance.currentUser!.displayName == null) {
                      return const SetupProfile();
                    } else {
                      return const LayoutApp();
                    }
                  } else {
                    return const LoginScreen();
                  }
                })
        ),
      ),
    );
  }
}
