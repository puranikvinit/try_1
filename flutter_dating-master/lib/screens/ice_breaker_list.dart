import 'dart:math';

import 'package:flutter/material.dart';
import 'package:folx_dating/screens/ice_breaker_detail.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

import '../CONSTANTS.dart';

class IceBreakerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IceBreakerSt();
  }
}

class _IceBreakerSt extends State<IceBreakerList> {
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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ice Breakers',
              style: getDefaultBoldTextStyle().copyWith(fontSize: 20)),
          Text(
            'Choose a question',
            style: getDefaultTextStyle().copyWith(fontSize: 12),
          )
        ]),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Stack(
          children: [
            ListView.separated(
              itemCount: ICE_BREAKERS_DEFAULT.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () =>
                      enterIceBreakerDetail(ICE_BREAKERS_DEFAULT[index]),
                  child: Card(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        ICE_BREAKERS_DEFAULT[index],
                        style: getDefaultDarkTextStyle().copyWith(
                            color: hexToColor("#808080"),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 14,
                );
              },
            ),
            Positioned(
                bottom: 40,
                right: 0,
                child: FloatingActionButton(
                  onPressed: shuffleAndEnter,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.shuffle,
                    color: secondaryBg,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void shuffleAndEnter() {
    final _random = new Random();
    int randomIndex = 1 + _random.nextInt(ICE_BREAKERS_DEFAULT.length - 1);
    String randomQues = ICE_BREAKERS_DEFAULT[randomIndex];
    enterIceBreakerDetail(randomQues);
  }

  void enterIceBreakerDetail(String question) {
    print('current question $question');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => IceBreakerDetail(question)));
  }
}
