import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rss_reader/utils/firebase_service.dart';
import 'package:rss_reader/view/news_list.dart';
import 'package:rss_reader/viewModel/news_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  FirebaseService service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Generic_Feed-icon.svg/1024px-Generic_Feed-icon.svg.png",
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                const Text(
                  "RSS Reader",
                  style: TextStyle(color: Colors.orange, fontSize: 35),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    child: Row(
                      children: const [
                        Expanded(
                            flex: 1,
                            child: FaIcon(
                              FontAwesomeIcons.google,
                            )),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Sign in with Google"),
                            ))
                      ],
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await service.signInwithGoogle();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                    create: (context) =>
                                        NewsViewModel()..fetchViewsList(null),
                                    child: const NewsListScreen())),
                            (route) => false);
                      } catch (e) {
                        if (e is FirebaseAuthException) {
                          print(e.message!);
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ButtonStyle(
                        // backgroundColor:
                        //     MaterialStateProperty.all<Color>(Colors.white),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
