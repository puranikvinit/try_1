import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/MessageList.dart';
import 'package:folx_dating/screens/home/ChatScreen.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class MessageListScreen extends StatefulWidget {
  final DatabaseService ds = new DatabaseService();
  @override
  State<StatefulWidget> createState() => _MsgListSt();
}

class _MsgListSt extends State<MessageListScreen> {
  bool isDataLoaded = false;
  @override
  void initState() {
    print("message list");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) getMessages();
    return Scaffold(
      body: Container(
          child: !isDataLoaded
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : msgLists.isNotEmpty
                  ? ListView.builder(
                      itemCount: msgLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        MessageList messageList = msgLists[index];
                        return ListTile(
                          leading: CircularProfileAvatar(
                            messageList.avatarUrl,
                            radius: 24,
                          ),
                          trailing: messageList.numOfUnreadMsg > 0
                              ? CircleAvatar(
                                  radius: 13,
                                  backgroundColor: secondaryBg,
                                  child: Center(
                                    child: Text(
                                      messageList.numOfUnreadMsg.toString(),
                                      style: getDefaultTextStyle(),
                                    ),
                                  ),
                                )
                              : Text(
                                  '${messageList.getDateString()}',
                                  style: getDefaultDarkTextStyle()
                                      .copyWith(color: Colors.grey),
                                ),
                          title: Text(
                            messageList.userName,
                            style: getDefaultDarkTextStyle().copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            messageList.lastMsg,
                            style: messageList.numOfUnreadMsg > 0
                                ? getDefaultDarkBoldTextStyle()
                                : getDefaultDarkTextStyle()
                                    .copyWith(color: Colors.grey),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(messageList)),
                            );
                          },
                        );
                      })
                  : Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(48),
                            child: Text(
                              'Matches are not present at the moment! \n\nPlease check-in some other time',
                              style: getDefaultDarkTextStyle()
                                  .copyWith(fontSize: 24, color: primaryBg),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )),
    );
  }

  List<MessageList> msgLists = List();
  void getMessages() {
    var list = widget.ds.getMessageList();
    list.then((value) {
      if (mounted) {
        setState(() {
          isDataLoaded = true;
          msgLists = value;
        });
      }
    });
  }
}
