import 'package:intl/intl.dart';

class MessageList {
  String avatarUrl;
  String userName;
  String lastMsg;
  int numOfUnreadMsg;
  int lastMsgTime;
  String roomId;

  MessageList(
      {this.avatarUrl = '',
      this.userName = '',
      this.roomId = '',
      this.lastMsg = '',
      this.numOfUnreadMsg = 0,
      this.lastMsgTime = 10});

  String getDateString() {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this.lastMsgTime);
    var format = new DateFormat("yMd");
    return format.format(date);
  }
}
