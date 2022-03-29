import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:folx_dating/screens/home/HomeScreen.dart';
import 'package:folx_dating/screens/splash/Splash.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:provider/provider.dart';

import 'auth/phone_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv().load('.env');
  runApp(FolxApplication());
}

class FolxApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: primaryBg,
          scaffoldBackgroundColor: primaryBg,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
