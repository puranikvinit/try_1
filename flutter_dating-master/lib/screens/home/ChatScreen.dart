import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/auth/auth.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/models/MessageList.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class ChatScreen extends StatefulWidget {
  final MessageList msgRoom;
  final DatabaseService _ds = new DatabaseService();
  ChatScreen(this.msgRoom);
  @override
  State<StatefulWidget> createState() => _ChatSt();
}

class _ChatSt extends State<ChatScreen> {
  bool isSendByMe = false;
  TextEditingController _controller = TextEditingController();

  Stream<QuerySnapshot> chats;

  @override
  void initState() {
    widget._ds.getConversationMessages(widget.msgRoom.roomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text(widget.msgRoom.userName),
      ),
      backgroundColor: Colors.white,
      body: Column(children: [
        Expanded(
          child: getChatList(),
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 36, top: 10),
          elevation: 4,
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  submitChatText();
                },
              ),
              hintText: 'Start Typing ...',
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: 24,
                bottom: 11,
                top: 14,
                right: 15,
              ),
            ),
            onFieldSubmitted: (text) => submitChatText(),
          ),
        )
      ]),
    );
  }

  void submitChatText() {
    print('submitted text  ${_controller.value.text}');
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        sent_by: FireBase.auth.currentUser.uid,
        messages: _controller.text,
        sent_at: Timestamp.now(),
      };

      widget._ds.addMessage(widget.msgRoom.roomId, chatMessageMap);

      setState(() {
        _controller.text = "";
      });
    }
  }

  Widget getChatList() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  print(snapshot.data.documents[index].data());
                  return MessageTile(
                      message: snapshot.data.documents[index].data()[messages],
                      sendByMe: FireBase.auth.currentUser.uid ==
                          snapshot.data.documents[index].data()[sent_by]);
                },
              )
            : Container();
      },
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
              color: sendByMe
                  ? hexToColor("#9649CB").withOpacity(0.4)
                  : hexToColor("#AAAAAA").withOpacity(0.4),
              borderRadius: sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )),
          child: Text(
            message,
            style: getDefaultDarkTextStyle(),
          ),
        )
      ],
    );
  }
}

/*Row(
                    mainAxisAlignment: isSendByMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .6),
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 16,
                          bottom: 16,
                        ),
                        decoration: BoxDecoration(
                            color: isSendByMe
                                ? hexToColor("#9649CB").withOpacity(0.4)
                                : hexToColor("#AAAAAA").withOpacity(0.4),
                            borderRadius: isSendByMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  )),
                        child: Text(
                          message,
                          style: getDefaultDarkTextStyle(),
                        ),
                      )
                    ],
                  );*/
