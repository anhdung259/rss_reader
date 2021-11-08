import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rss_reader/data_sources/get_rss.dart';
import 'package:webfeed/webfeed.dart';

class NewsViewModel with ChangeNotifier {
  RssFeed? rssFeed;
  String? error;
  fetchViewsList(String? rssUrl) async {
    try {
      clearError();
      rssFeed = await GetRss.fetchRss(rssUrl);
    } on Exception catch (e) {
      notifyError("RssUrl is invalid");
      log(e.toString());
    }
    notifyListeners();
  }

  void notifyError(dynamic message) {
    error = message.toString();
  }

  void clearError() {
    error = null;
  }
}
