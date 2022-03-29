import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folx_dating/firebase/cloud_store.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

import '../CONSTANTS.dart';

class IceBreakerDetail extends StatefulWidget {
  final String defaultQuestion;
  final String defaultAns;
  IceBreakerDetail(this.defaultQuestion, {this.defaultAns = ""});
  @override
  State<StatefulWidget> createState() {
    return _IceBreakerDetailSt();
  }
}

class _IceBreakerDetailSt extends State<IceBreakerDetail> {
  String ques = "";
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.value = TextEditingValue(text: widget.defaultAns);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ice Breakers',
            style: getDefaultBoldTextStyle().copyWith(fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              children: [
                Card(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          ques.isEmpty ? widget.defaultQuestion : ques,
                          style: getDefaultDarkTextStyle().copyWith(
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 28, vertical: 23),
                          child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: getDefaultDarkBoldTextStyle()
                                  .copyWith(fontSize: 20),
                              controller: _controller,
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Write something interesting',
                                  hintStyle: getDefaultDarkBoldTextStyle()
                                      .copyWith(
                                          fontSize: 20,
                                          color:
                                              darkFontColor.withOpacity(0.6)))),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    padding: EdgeInsets.only(
                      top: 12,
                      left: 16,
                      bottom: 20,
                      right: 16,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                      'Think of something fun, quirky and entertaining to get the conversation going!'),
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                ),
                Container(
                  child: Row(
                    children: [
                      Text('At a loss for words? '),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Choose Question',
                          style: getDefaultDarkTextStyle().copyWith(
                              color: secondaryBg, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(right: 14, left: 14),
                )
              ],
            ),
            Positioned(
                bottom: 40,
                right: 0,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: "shuffle",
                      onPressed: shuffleQuestion,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.shuffle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    FloatingActionButton(
                      heroTag: "tick",
                      onPressed: saveIceBreaker,
                      backgroundColor: secondaryBg,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void shuffleQuestion() {
    final _random = new Random();
    int randomIndex = 1 + _random.nextInt(ICE_BREAKERS_DEFAULT.length - 1);
    setState(() {
      ques = ICE_BREAKERS_DEFAULT[randomIndex];
      _controller.clear();
    });
  }

  void saveIceBreaker() {
    var response = _controller.value.text;
    if (response != null && response.isNotEmpty) {
      if (ques.isEmpty) {
        ques = widget.defaultQuestion;
      }
      DatabaseService ds = new DatabaseService();
      ds.addMyIceBreaker(ques, response);
      Navigator.pop(context);
    }
  }
}
