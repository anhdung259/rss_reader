import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class GetRss {
  static Future<RssFeed> fetchRss(String? rssUrl) async {
    String url;
    if (rssUrl == null || rssUrl == "") {
      url = "https://vnexpress.net/rss/tin-moi-nhat.rss";
    } else {
      if (rssUrl.contains("https://")) {
        url = rssUrl;
      } else {
        url = "https://" + rssUrl;
      }
    }
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });
    var rssFeed = RssFeed.parse(utf8.decode(response.bodyBytes));

    return rssFeed;
  }
}
