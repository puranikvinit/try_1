import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/models/User.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserDetail extends StatefulWidget {
  final FolxUser user;
  final VoidCallback parentPgAction;

  UserDetail(this.user, this.parentPgAction);

  @override
  State<StatefulWidget> createState() => _UserEmail();
}

class _UserEmail extends State<UserDetail> {
  bool isSkipVisible = true;
  bool isUserEmailFinished = false;
  bool isDateVisible = false;
  String userName = "";
  int userAge = 18;
  String dob = "DD/MM/YYYY";
  DateTime today = new DateTime.now();

  TextEditingController controller = TextEditingController(text: '18');

  void setIsSkipVisible(bool isVisible) {
    setState(() {
      isSkipVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              //user emaiil container
              Container(
                margin: EdgeInsets.only(
                  left: 48,
                  right: 48,
                ),
                child: Visibility(
                  visible: !isUserEmailFinished,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add a backup email address",
                        style: getDefaultBoldTextStyle(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Don’t worry, we won’t send you any spam 🤭",
                        style: getDefaultTextStyle(),
                      ),
                      SizedBox(
                        height: 68,
                      ),
                      TextField(
                          style: TextStyle(color: Colors.white),
                          onChanged: (text) {
                            bool isValid = EmailValidator.validate(text);
                            print("First text field: $isValid");
                            setIsSkipVisible(!isValid);
                            widget.user.emailId = isValid ? text : null;
                          },
                          decoration:
                              getDefaultInputDecoration("someone@example.com")
                                  .copyWith(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(4),
                          )),
                    ],
                  ),
                ),
              ),
              //user name and age container
              Container(
                margin: EdgeInsets.only(
                  left: 48,
                  right: 48,
                ),
                child: Visibility(
                  visible: isUserEmailFinished,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Looks like you’re new around here",
                        style: getDefaultBoldTextStyle(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "What should we call you?",
                        style: getDefaultTextStyle(),
                      ),
                      SizedBox(
                        height: 68,
                      ),
                      Focus(
                        onFocusChange: (hasFocus) {
                          setState(() {
                            if (isDateVisible) {
                              isDateVisible = false;
                            }
                          });
                        },
                        child: TextField(
                          onChanged: (text) {
                            userName = text;
                          },
                          decoration:
                              getDefaultInputDecoration("Name").copyWith(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(4),
                          ),
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      SizedBox(
                        height: 120,
                      ),
                      Text(
                        "Select your date of birth - ",
                        style: getDefaultTextStyle(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isDateVisible = !isDateVisible;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: dob,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  )),
                              WidgetSpan(
                                  child: Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.calendar_today,//calendar_today_rounded
                                  color: Colors.white,
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: isDateVisible,
                        child: SfDateRangePicker(
                          backgroundColor: Colors.white,
                          maxDate: today.subtract(
                              new Duration(days: (userAge * 365) + 5)),
                          onSelectionChanged: (args) {
                            var date =
                                DateFormat('dd/MM/yyyy').format(args.value);
                            final birthday = args.value;
                            final difference =
                                ((today.difference(birthday).inDays) / 365)
                                    .floor();
                            userAge = difference;
                            setState(() {
                              dob = date;
                              isDateVisible = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //button and skip
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Spacer(),
                    Visibility(
                      visible: isSkipVisible,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 32),
                        child: InkWell(
                          onTap: () {
                            if (!isUserEmailFinished) {
                              setState(() {
                                isUserEmailFinished = true;
                                isSkipVisible = false;
                              });
                            }
                          },
                          child: Text(
                            "Skip for now",
                            style: getDefaultTextStyle().copyWith(
                              color: hexToColor("#AAAAAA"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Visibility(
                      visible: !isSkipVisible,
                      child: Container(
                        margin: EdgeInsets.only(right: 24, bottom: 40),
                        child: FloatingActionButton(
                          child: Icon(Icons.arrow_forward),
                          backgroundColor: secondaryBg,
                          onPressed: () {
                            if (isUserEmailFinished) {
                              if (userName.isEmpty) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Empty Name"),
                                ));
                                return null;
                              } else {
                                widget.user.userName = userName;
                                widget.user.dob = dob;
                                widget.user.userAge = userAge;
                                widget.parentPgAction();
                              }
                            }
                            if (!isUserEmailFinished) {
                              setState(() {
                                isUserEmailFinished = true;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
