extension FormattedDate on DateTime {
  String get formatted => "$year"
      "-"
      "${month < 10 ? "0$month" : "$month"}"
      "-"
      "${day < 10 ? "0$day" : day}"
      " "
      "${hour < 10 ? "0$hour" : "$hour"}"
      ":"
      "${minute < 10 ? "0$minute" : "$minute"}";
}
