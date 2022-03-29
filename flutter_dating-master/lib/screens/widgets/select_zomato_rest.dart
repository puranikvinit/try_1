import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:folx_dating/models/Restaurant.dart';
import 'package:folx_dating/network/zomato.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';
import 'package:geolocator/geolocator.dart';

class ChooseRestaurantScreen extends StatefulWidget {
  final List<Restaurant> restList = new List();
  final Position position;
  ChooseRestaurantScreen(this.position);

  @override
  State<StatefulWidget> createState() => _ChoseRest();
}

class _ChoseRest extends State<ChooseRestaurantScreen> {
  bool isLoadVisiblity = false;
  String _restName;
  List _responseRestList = new List();

  ZomatoNetwork net = ZomatoNetwork();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        leading: Center(
          child: InkWell(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context, widget.restList);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add your 3 favourite date spots",
                      style: getDefaultBoldTextStyle(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      height: (widget.restList.length * 100).toDouble(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.restList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: DottedBorder(
                                color: hexToColor("#AAAAAA"),
                                child: Center(
                                  child: FlatButton.icon(
                                    icon: Icon(
                                      Icons.restaurant,
                                      color: secondaryBg,
                                    ),
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    onPressed: null,
                                    label: Expanded(
                                      child: Text(
                                        widget.restList[index].restName,
                                        style: getDefaultBoldTextStyle()
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                                letterSpacing: 0.14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                          primaryColor: Colors.white,
                          hintColor: Colors.white,
                          iconTheme: IconThemeData(color: Colors.white)),
                      child: TextFormField(
                        onChanged: (text) {
                          _restName = text;
                        },
                        style: getDefaultTextStyle().copyWith(
                          decorationColor: Colors.white,
                        ),
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          _searchRestaurant();
                          // _clearRestaurantList();
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.restaurant),
                          hintText: "Enter Restaurant Name",
                          border: OutlineInputBorder(),
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () => _searchRestaurant(),
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: isLoadVisiblity,
                      child: Center(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: CircularProgressIndicator(
                            backgroundColor: secondaryBg,
                            semanticsLabel: "Searching ...",
                          ),
                        ),
                      ),
                    ),
                    (_responseRestList == null || _responseRestList.length == 0)
                        ? Text('')
                        : SizedBox(
                            height: 300,
                            child: ListView(
                              children: _responseRestList.map((rest) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: secondaryBg,
                                  child: ListTile(
                                    onTap: () {
                                      var restaurant = rest['restaurant'];
                                      String item = restaurant['name'];
                                      String id = restaurant['id'];
                                      String imageUrl =
                                          restaurant['featured_image'];
                                      double latitude = double.parse(
                                          restaurant['location']['latitude']);
                                      double longitude = double.parse(
                                          restaurant['location']['longitude']);
                                      String locality =
                                          restaurant['location']['locality'];
                                      if (!widget.restList.contains(id)) {
                                        widget.restList.add(Restaurant(id, item,
                                            imageUrl: imageUrl,
                                            latitude: latitude,
                                            longitude: longitude,
                                            locality: locality));
                                      }
                                      _refreshList();
                                    },
                                    title: Text(
                                      rest['restaurant']['name'],
                                      style: getDefaultTextStyle(),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _searchRestaurant() async {
    var pos = widget.position;
    setState(() {
      isLoadVisiblity = true;
    });

    net.searchRest(_restName, pos).then((value) {
      setState(() {
        isLoadVisiblity = false;
        _responseRestList = value;
      });
    });

    // print(response);
  }

  void _refreshList() {
    setState(() {});
  }
}
