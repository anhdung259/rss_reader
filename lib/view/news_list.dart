import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rss_reader/model/news.dart';
import 'package:rss_reader/utils/firebase_service.dart';
import 'package:rss_reader/utils/general_helper.dart';
import 'package:rss_reader/view/login.dart';
import 'package:rss_reader/view/news_detail.dart';
import 'package:rss_reader/view/news_save_list.dart';
import 'package:rss_reader/viewModel/news_save_view_model.dart';
import 'package:rss_reader/viewModel/news_view_model.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  TextEditingController rssUrlController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  onRefresh(NewsViewModel newsViewModel, BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    await newsViewModel.fetchViewsList(rssUrlController.text);
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "RSS Reader",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          drawer: drawer(),
          body:
              Consumer<NewsViewModel>(builder: (context, newsViewModel, child) {
            if (newsViewModel.error != null) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                GeneralHelper.showSnackBar(
                    context, newsViewModel.error!, Colors.red);
              });
            }
            return newsViewModel.rssFeed != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller: rssUrlController,
                                      decoration: const InputDecoration(
                                          hintText: "Input Rss url"),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await onRefresh(newsViewModel, context);
                                      },
                                      child: const Text("Load")),
                                )
                              ],
                            )),
                        Text(
                          newsViewModel.rssFeed!.title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                        Expanded(
                          flex: 9,
                          child: SmartRefresher(
                            controller: refreshController,
                            onRefresh: () => onRefresh(newsViewModel, context),
                            child: ListView.builder(
                                itemCount: newsViewModel.rssFeed!.items!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: title(newsViewModel
                                        .rssFeed!.items![index].title),
                                    subtitle: subtitle(
                                        GeneralHelper.formatDateWithFormat(
                                            newsViewModel
                                                .rssFeed!.items![index].pubDate
                                                .toString())),
                                    trailing: rightIcon(),
                                    contentPadding: const EdgeInsets.all(5.0),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewsDetails(
                                              news: News(
                                                  link: newsViewModel.rssFeed!
                                                      .items![index].link!,
                                                  timePublic: newsViewModel
                                                      .rssFeed!
                                                      .items![index]
                                                      .pubDate!
                                                      .toString(),
                                                  title: newsViewModel.rssFeed!
                                                      .items![index].title!)),
                                        )),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                    ),
                  );
          })),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey[300]),
            child: Column(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 80.0,
                    width: 80.0,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    imageUrl: user!.photoURL!,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(user!.displayName!,
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              FirebaseService service = FirebaseService();
              await service.signOutFromGoogle();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                        create: (context) =>
                            NewsSaveViewModel()..fetchNewsSaveList(),
                        child: const NewsSaveListScreen())),
              );
            },
            leading: const Icon(Icons.save),
            title: const Text("News Saved"),
          ),
          ListTile(
            onTap: () async {
              FirebaseService service = FirebaseService();
              await service.signOutFromGoogle();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
          )
        ],
      ),
    );
  }

  title(title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w300,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  rightIcon() {
    return const Icon(
      Icons.keyboard_arrow_right,
      size: 30.0,
    );
  }
}
