import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rss_reader/data_sources/handle_db.dart';
import 'package:rss_reader/model/news.dart';

class NewsSaveViewModel with ChangeNotifier {
  DatabaseHandler db = DatabaseHandler();
  List<News>? newsSaveList = [];
  String? error;
  fetchNewsSaveList() async {
    await db.initializeDB();
    try {
      newsSaveList = await db.fecthAllNews();
      newsSaveList = newsSaveList!.reversed.toList();
    } on Exception catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  deleteNewsSave(int id) async {
    try {
      await db.delete(id);
      fetchNewsSaveList();
    } on Exception catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
