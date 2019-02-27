import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  bool isLoading = true;
  List videos = [];

  fetchData() async {
    final String url = "http://api.letsbuildthatapp.com/youtube/home_feed";
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final List videoJson = map['videos'];
      this.videos = videoJson;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Mazlan hensem"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  fetchData();
                })
          ],
        ),
        body: new Center(
          child: isLoading ? new CircularProgressIndicator() : buildListView(),
        ),
      ),
    );
  }

  Padding buildListView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new ListView.builder(
          itemCount: this.videos.length,
          itemBuilder: (context, i) {
            return new Column(
              children: <Widget>[
                new Image.network(videos[i]['imageUrl']),
                new Text(this.videos[i]['name'], style: new TextStyle(fontSize: 16.0),),
                new Divider()
              ],
            );
          }),
    );
  }
}
