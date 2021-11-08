class News {
  int? id;
  String link;
  String timePublic;
  String title;
  News(
      {this.id,
      required this.link,
      required this.timePublic,
      required this.title});
  News.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        timePublic = res["timePublic"],
        link = res["link"];
  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'timePublic': timePublic, 'link': link};
  }
}
