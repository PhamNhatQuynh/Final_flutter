import 'package:final_quizlet_english/screens/Splash.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/blocs/topic/TopidDetailBloc.dart';
import 'package:final_quizlet_english/firebase_options.dart';
import 'package:final_quizlet_english/screens/SignIn.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/AuthProvider.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/VocabFavDao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:final_quizlet_english/screens/TopicFlashcard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AuthenticateProvider(
      auth: AuthService(),
      child: MultiBlocProvider(providers: [
        BlocProvider<TopicBloc> ( 
        create: (context) => TopicBloc(TopicDao())
        ),
        BlocProvider<TopicDetailBloc> (
        create: (context) => TopicDetailBloc(TopicDao(), VocabularyFavDao())
        ),
      ],child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const HomeController(),
      ),)
    );
  }
}

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthenticateProvider.of(context)!.auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          
          print("Status: " + signedIn.toString());
          // auth.signOut();
          
          return SplashScreen(signedIn: (signedIn && snapshot.data!.emailVerified));
        }
        return Container(
          color: Colors.black,
        );
      },
    );
  }
}
