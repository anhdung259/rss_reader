import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rss_reader/utils/general_helper.dart';

import 'package:rss_reader/view/news_detail.dart';
import 'package:rss_reader/viewModel/news_save_view_model.dart';

class NewsSaveListScreen extends StatefulWidget {
  const NewsSaveListScreen({Key? key}) : super(key: key);

  @override
  _NewsSaveListScreenState createState() => _NewsSaveListScreenState();
}

class _NewsSaveListScreenState extends State<NewsSaveListScreen> {
  TextEditingController rssUrlController = TextEditingController();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  onRefresh(NewsSaveViewModel viewModel, BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    await viewModel.fetchNewsSaveList();
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
              "News saved",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body:
              Consumer<NewsSaveViewModel>(builder: (context, viewModel, child) {
            return viewModel.newsSaveList!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: SmartRefresher(
                      controller: refreshController,
                      onRefresh: () => onRefresh(viewModel, context),
                      child: ListView.builder(
                          itemCount: viewModel.newsSaveList!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Slidable(
                              actionPane: const SlidableDrawerActionPane(),
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'Remove',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () async {
                                    await viewModel.deleteNewsSave(
                                        viewModel.newsSaveList![index].id!);
                                    GeneralHelper.showSnackBar(context,
                                        "News is removed", Colors.green);
                                  },
                                ),
                              ],
                              child: ListTile(
                                title:
                                    title(viewModel.newsSaveList![index].title),
                                subtitle: subtitle(
                                    GeneralHelper.formatDateWithFormat(viewModel
                                        .newsSaveList![index].timePublic
                                        .toString())),
                                trailing: rightIcon(),
                                contentPadding: const EdgeInsets.all(5.0),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetails(
                                          news: viewModel.newsSaveList![index]),
                                    )),
                              ),
                            );
                          }),
                    ),
                  )
                : const Center(
                    child: SizedBox(
                      child: Text("List empty!"),
                    ),
                  );
          })),
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

  void showSnackBarError(BuildContext context, String message) {
    final snackBar =
        SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
