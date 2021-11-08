import 'package:flutter/material.dart';
import 'package:rss_reader/data_sources/handle_db.dart';
import 'package:rss_reader/model/news.dart';
import 'package:rss_reader/utils/general_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({Key? key, required this.news}) : super(key: key);

  final News news;

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  DatabaseHandler db = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    db.initializeDB();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news.title),
      ),

      body: Center(
        child: WebView(
          initialUrl: widget.news.link,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await db.insertNew(widget.news);
          GeneralHelper.showSnackBar(context, "News is saved", Colors.green);
        },
        tooltip: 'Save news to read late',
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
