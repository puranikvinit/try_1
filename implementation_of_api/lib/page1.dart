//KARKALA SRINIVASA VENKATARAMANA
//OM JAI DURGE MAA

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Movies APP",
    home: HomeScreen2(),
  ));
}

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  var listOfMovies = [];
  var mapresponse;

  Future fetchMovies() async {
    String url = "https://imdb-api.com/en/API/Top250Movies/k_hdxo37su";
    var response = await http.get(Uri.parse(url));
    setState(() {
      mapresponse = jsonDecode(response.body);
      listOfMovies = mapresponse["items"];
    });
  }

  void getTrailer(int i) async {
    var mapTrailer;
    String urlTrailer =
        "https://imdb-api.com/en/API/YouTubeTrailer/k_hdxo37su/${listOfMovies[i]["id"]}";
    var response = await http.get(Uri.parse(urlTrailer));
    setState(() {
      mapTrailer = jsonDecode(response.body);
    });
    if (!await launch(mapTrailer["videoUrl"])) throw 'Could not launch';
  }

  void getWiki(int i) async {
    var mapWiki;
    String urlWiki =
        "https://imdb-api.com/en/API/Wikipedia/k_hdxo37su/${listOfMovies[i]["id"]}";
    var response = await http.get(Uri.parse(urlWiki));
    setState(() {
      mapWiki = jsonDecode(response.body);
    });
    if (!await launch(mapWiki["url"])) throw 'Could not launch';
  }

  @override
  void initState() {
    fetchMovies();
    super.initState();
  }

  Widget homey() {
    return ListView.builder(
        itemCount: listOfMovies.length,
        itemBuilder: (context, i) {
          return Card(
            child: ExpansionTile(
              leading: Image.network(listOfMovies[i]["image"]),
              title: Text(listOfMovies[i]["title"]),
              subtitle: Text(listOfMovies[i]["fullTitle"]),
              children: [
                TextButton(
                    onPressed: () {
                      getTrailer(i);
                    },
                    child: Text("Youtube Trailer")),
                TextButton(
                    onPressed: () {
                      getWiki(i);
                    },
                    child: Text("Know More"))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Top 250 Movies"),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) {
                //return SearchScreen();
                //}));
              },
              icon: Icon(Icons.search),
              tooltip: "Search For Movies",
            ),
          ],
        ),
        body: homey());
  }
}
