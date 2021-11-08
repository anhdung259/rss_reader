import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/view/login.dart';
import 'package:rss_reader/view/news_list.dart';
import 'package:rss_reader/viewModel/news_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RSS Reader',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: user != null
          ? ChangeNotifierProvider(
              create: (context) => NewsViewModel()..fetchViewsList(null),
              child: const NewsListScreen())
          : const LoginScreen(),
    );
  }
}
