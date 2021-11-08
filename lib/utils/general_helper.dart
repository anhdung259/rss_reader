import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class GeneralHelper {
  static void showSnackBar(BuildContext context, String message, Color? color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static formatDateWithFormat(
    String date,
  ) {
    DateTime dateTime = DateTime.parse(date);

    return formatDate(
        dateTime,
        [
          DD,
          ', ',
          dd,
          '/',
          mm,
          '/',
          yyyy,
          ', ',
          HH,
          '\\h',
          nn,
        ],
        locale: const VietnameseDateLocale());
  }
}
